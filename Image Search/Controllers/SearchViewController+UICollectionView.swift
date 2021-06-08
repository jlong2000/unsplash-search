//
//  SearchViewController+UICollectionView.swift
//  Image Search
//
//  Created by Jiang Long on 6/4/21.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath)

        guard let photoCell = cell as? PhotoCell, let photo = dataSource.item(at: indexPath.item) else { return cell }

        photoCell.configure(with: photo)

        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingView.reuseIdentifier, for: indexPath)

        guard let pagingView = view as? PagingView else { return view }

        pagingView.isLoading = dataSource.isFetching

        return pagingView
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let prefetchCount = 19
        if indexPath.item == dataSource.items.count - prefetchCount {
            fetchNextItems()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = dataSource.item(at: indexPath.item), collectionView.hasActiveDrag == false else { return }

        handleSelectPhoto(with: photo)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = dataSource.item(at: indexPath.item) else { return .zero }

        let width = collectionView.frame.width
        let height = CGFloat(photo.height) * width / CGFloat(photo.width)
        return CGSize(width: width, height: height)
    }
}

// MARK: - WaterfallLayoutDelegate
extension SearchViewController: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = dataSource.item(at: indexPath.item) else { return .zero }

        return CGSize(width: photo.width, height: photo.height)
    }
}
