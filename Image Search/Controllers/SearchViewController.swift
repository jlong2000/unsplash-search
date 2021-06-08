//
//  SearchViewController.swift
//  Image Search
//
//  Created by Jiang Long on 6/4/21.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - UI Components

    private lazy var searchController: UISearchController = {
        let searchController = UnsplashSearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("search.placeholder", value: "Search photos", comment: "")
        searchController.searchBar.autocapitalizationType = .none
        return searchController
    }()

    private lazy var layout = WaterfallLayout(with: self)

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.register(PagingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PagingView.reuseIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var dataSource: PagedDataSource = editorialDataSource {
        didSet {
            oldValue.cancelFetch()
            dataSource.delegate = self
        }
    }

    private let editorialDataSource = PhotosDataSourceFactory.collection(identifier: Configuration.shared.editorialCollectionId).dataSource

    private var searchText: String?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        dataSource.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if dataSource.items.count == 0 {
            refresh()
        }
    }

    // MARK: - Private Functions

    private func setupUI() {

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true

        view.addSubview(collectionView)
        view.addSubview(spinner)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }

    private func setSearchText(_ text: String?) {
        Configuration.shared.query = text
        if let text = text, text.isEmpty == false {
            dataSource = PhotosDataSourceFactory.search(query: text).dataSource
            searchText = text
        } else {
            dataSource = editorialDataSource
            searchText = nil
        }
    }

    private func refresh() {
        guard dataSource.items.isEmpty else { return }

        if dataSource.isFetching == false && dataSource.items.count == 0 {
            dataSource.reset()
            reloadData()
            fetchNextItems()
        }
    }

    private func reloadData() {
        collectionView.reloadData()
    }

    func fetchNextItems() {
        dataSource.fetchNextPage()
    }

    private func scrollToTop() {
        let contentOffset = CGPoint(x: 0, y: -collectionView.safeAreaInsets.top)
        collectionView.setContentOffset(contentOffset, animated: false)
    }

    private func showEmptyView(with state: EmptyViewState) {
        emptyView.state = state

        guard emptyView.superview == nil else { return }

        spinner.stopAnimating()

        view.addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func hideEmptyView() {
        emptyView.removeFromSuperview()
    }

    // MARK: - Actions

    func handleSelectPhoto(with photo: UnsplashPhoto) {
        let detailVC = PhotoDetailViewController(photo: photo)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }

        setSearchText(text)
        refresh()
        scrollToTop()
        hideEmptyView()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard self.searchText != nil && searchText.isEmpty else { return }

        setSearchText(nil)
        refresh()
        reloadData()
        scrollToTop()
        hideEmptyView()
    }
}

// MARK: - UIScrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchController.searchBar.isFirstResponder {
            searchController.searchBar.resignFirstResponder()
        }
    }
}

// MARK: - PagedDataSourceDelegate
extension SearchViewController: PagedDataSourceDelegate {
    func dataSourceWillStartFetching(_ dataSource: PagedDataSource) {
        if dataSource.items.count == 0 {
            spinner.startAnimating()
        }
    }

    func dataSource(_ dataSource: PagedDataSource, didFetch items: [UnsplashPhoto]) {
        guard dataSource.items.count > 0 else {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.showEmptyView(with: .noResults)
            }

            return
        }

        let newPhotosCount = items.count
        let startIndex = self.dataSource.items.count - newPhotosCount
        let endIndex = startIndex + newPhotosCount
        var newIndexPaths = [IndexPath]()
        for index in startIndex..<endIndex {
            newIndexPaths.append(IndexPath(item: index, section: 0))
        }

        DispatchQueue.main.async { [unowned self] in
            self.spinner.stopAnimating()
            self.hideEmptyView()

            let hasWindow = self.collectionView.window != nil
            let collectionViewItemCount = self.collectionView.numberOfItems(inSection: 0)
            if hasWindow && collectionViewItemCount < dataSource.items.count {
                self.collectionView.insertItems(at: newIndexPaths)
            } else {
                self.reloadData()
            }
        }
    }

    func dataSource(_ dataSource: PagedDataSource, fetchDidFailWithError error: Error) {
        let state: EmptyViewState = (error as NSError).isNoInternetConnectionError() ? .noInternetConnection : .serverError

        DispatchQueue.main.async {
            self.showEmptyView(with: state)
        }
    }
}
