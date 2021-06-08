//
//  PhotoDetailViewController.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import UIKit
import QuickLook

class PhotoDetailViewController: UIViewController {

    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left_arrow"), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let detailContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = avatarHeight / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = photo.user.displayName
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var propertiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var viewsCountPropertyView: PropertyView = {
        let propertyView = PropertyView(title: NSLocalizedString("property.views", value: "Views", comment: ""))
        return propertyView
    }()

    private let spaceLine1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var downloadsCountPropertyView: PropertyView = {
        let propertyView = PropertyView(title: NSLocalizedString("property.downloads", value: "Downloads", comment: ""))
        return propertyView
    }()

    private let spaceLine2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var resolutionPropertyView: PropertyView = {
        let propertyView = PropertyView(title: NSLocalizedString("property.resolution", value: "Resolution", comment: ""),
                                        value: "\(photo.width)x\(photo.height)")
        return propertyView
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleSaveTapped), for: .touchUpInside)
        button.alpha = 0.5
        button.backgroundColor = .label
        button.isEnabled = false
        button.layer.cornerRadius = saveButtonHeight / 2
        button.setTitle(NSLocalizedString("button.save.title", value: "Save", comment: ""), for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var detailContainerLeadingConstraint: NSLayoutConstraint = {
        let layoutConstraint = detailContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        layoutConstraint.priority = UILayoutPriority(rawValue: 999)
        return layoutConstraint
    }()

    // MARK: - Properties
    private let photo: UnsplashPhoto
    private let imageDownloader = ImageDownloader()
    private let screenScale = UIScreen.main.scale

    private let saveButtonHeight: CGFloat = 56
    private let avatarHeight: CGFloat = 44

    private var photoLoaded: Bool = false {
        didSet {
            if photoLoaded {
                saveButton.alpha = 1
                saveButton.isEnabled = true
            } else {
                saveButton.alpha = 0.5
                saveButton.isEnabled = true
            }
        }
    }

    // MARK: - Initializer

    init(photo: UnsplashPhoto) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadAvatar { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadPhoto()
        }
        loadStatistics()
    }
    
    // MARK: - Private Functions
    private func setupUI() {

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))

        view.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(detailContainer)
        detailContainer.addSubview(avatar)
        detailContainer.addSubview(nameLabel)
        detailContainer.addSubview(propertiesStackView)
        propertiesStackView.addArrangedSubview(viewsCountPropertyView)
        propertiesStackView.addArrangedSubview(spaceLine1)
        propertiesStackView.addArrangedSubview(downloadsCountPropertyView)
        propertiesStackView.addArrangedSubview(spaceLine2)
        propertiesStackView.addArrangedSubview(resolutionPropertyView)
        detailContainer.addSubview(saveButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),

            detailContainerLeadingConstraint,
            detailContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            detailContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 500),

            avatar.topAnchor.constraint(equalTo: detailContainer.topAnchor, constant: 20),
            avatar.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor, constant: 20),
            avatar.widthAnchor.constraint(equalTo: avatar.heightAnchor),
            avatar.heightAnchor.constraint(equalToConstant: avatarHeight),

            nameLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor, constant: -20),

            propertiesStackView.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 42),
            propertiesStackView.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor, constant: 46),
            propertiesStackView.centerXAnchor.constraint(equalTo: detailContainer.centerXAnchor),
            propertiesStackView.heightAnchor.constraint(equalToConstant: 60),

            spaceLine1.widthAnchor.constraint(equalToConstant: 1),
            spaceLine1.heightAnchor.constraint(equalTo: propertiesStackView.heightAnchor),
            spaceLine2.widthAnchor.constraint(equalToConstant: 1),
            spaceLine2.heightAnchor.constraint(equalTo: propertiesStackView.heightAnchor),

            saveButton.topAnchor.constraint(equalTo: propertiesStackView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: detailContainer.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: detailContainer.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: saveButtonHeight),
        ])
    }

    private func loadAvatar(completion: @escaping (() -> Void)) {
        if let profileImageURL = photo.user.profileImage[.small] {
            imageDownloader.downloadPhoto(with: profileImageURL) {[weak self] image, _ in
                guard let strongSelf = self else { return }
                strongSelf.avatar.image = image
                completion()
            }
        } else {
            completion()
        }
    }

    private func loadPhoto() {
        guard let regularUrl = photo.urls[.regular] else { return }

        let url = sizedImageURL(from: regularUrl)

        imageDownloader.downloadPhoto(with: url, completion: { [weak self] (image, isCached) in
            guard let strongSelf = self, strongSelf.imageDownloader.isCancelled == false else { return }

            if isCached {
                strongSelf.imageView.image = image
                strongSelf.photoLoaded = true
            } else {
                UIView.transition(with: strongSelf.imageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.imageView.image = image
                }) { _ in
                    strongSelf.photoLoaded = true
                }
            }
        })
    }

    private func sizedImageURL(from url: URL) -> URL {
        view.layoutIfNeeded()
        return url.appending(queryItems: [
            URLQueryItem(name: "w", value: "\(UIScreen.main.bounds.width)"),
            URLQueryItem(name: "dpr", value: "\(Int(screenScale))")
        ])
    }

    private func loadStatistics() {
        let request = GetPhotoStatisticsRequest(id: photo.identifier)
        request.completionBlock = {[weak self] in
            guard let strongSelf = self else { return }
            if let error = request.error {
                // we got back an error!
                let ac = UIAlertController(title: NSLocalizedString("error.serverError.title", value: "Server error", comment: ""),
                                           message: error.localizedDescription,
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: NSLocalizedString("error.serverError.button", value: "Dismiss", comment: ""),
                                           style: .default))
                strongSelf.present(ac, animated: true)
                return
            }

            guard let statistics = request.statistics else {
                let ac = UIAlertController(title: NSLocalizedString("error.serverError.title", value: "Server error", comment: ""),
                                           message: NSLocalizedString("error.serverError.description", value: "Oops! Something's wrong. Please try again.", comment: ""),
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: NSLocalizedString("error.serverError.button", value: "Dismiss", comment: ""),
                                           style: .default))
                strongSelf.present(ac, animated: true)
                return
            }

            strongSelf.viewsCountPropertyView.setValue(String(statistics.views.total))
            strongSelf.downloadsCountPropertyView.setValue(String(statistics.downloads.total))
        }

        let operationQueue = OperationQueue(with: "com.unsplash.photoStatistics")
        operationQueue.addOperationWithDependencies(request)
    }

    // MARK: - Actions
    @objc private func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
    }

    @objc private func handleTapGesture() {
        detailContainer.isHidden = !detailContainer.isHidden
    }

    @objc private func handleSaveTapped() {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: NSLocalizedString("error.saveError.title", value: "Save error", comment: ""),
                                       message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("error.saveError.button", value: "OK", comment: ""),
                                       style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: NSLocalizedString("alert.saveSuccess.title", value: "Saved!", comment: ""),
                                       message: NSLocalizedString("alert.saveSuccess.message", value: "Your altered image has been saved to your photos.", comment: ""),
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("alert.saveSuccess.button", value: "OK", comment: ""),
                                       style: .default))
            present(ac, animated: true)

            saveButton.alpha = 0.5
            saveButton.isEnabled = true
        }
    }
}
