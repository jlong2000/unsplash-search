//
//  EmptyView.swift
//  Image Search
//
//  Created by Jiang Long on 6/4/21.
//

import UIKit

enum EmptyViewState {
    case noResults
    case noInternetConnection
    case serverError

    var title: String {
        switch self {
        case .noResults:
            return NSLocalizedString("error.noResults.title", value: "No results", comment: "")
        case .noInternetConnection:
            return NSLocalizedString("error.noInternetConnection.title", value: "No Internet Connection", comment: "")
        case .serverError:
            return NSLocalizedString("error.serverError.title", value: "Server error", comment: "")
        }
    }

    var description: String {
        switch self {
        case .noResults:
            return NSLocalizedString("error.noResults.description", value: "Please update your search and try again.", comment: "")
        case .noInternetConnection:
            return NSLocalizedString("error.noInternetConnection.description", value: "You must connect to a Wi-Fi or cellular data network to access Unsplash.", comment: "")
        case .serverError:
            return NSLocalizedString("error.serverError.description", value: "Oops! Something's wrong. Please try again.", comment: "")
        }
    }
}

class EmptyView: UIView {

    // MARK: - Properties

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()

    var state: EmptyViewState? {
        didSet {
            setupState()
        }
    }

    // MARK: - Lifetime

    init() {
        super.init(frame: .zero)

        backgroundColor = .systemBackground
        setupContainerView()
        setupTitleLabel()
        setupDescriptionLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupContainerView() {
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.bottomAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Constants.margin),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -Constants.margin)
        ])
    }

    private func setupDescriptionLabel() {
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.padding),
            descriptionLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Constants.margin),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -Constants.margin)
        ])
    }

    private func setupState() {
        titleLabel.text = state?.title
        descriptionLabel.text = state?.description
    }

}

// MARK: - Constants
private extension EmptyView {
    struct Constants {
        static let margin: CGFloat = 20.0
        static let padding: CGFloat = 10.0
    }
}
