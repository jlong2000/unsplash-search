//
//  PropertyView.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import UIKit

class PropertyView: UIStackView {

    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = title
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = value
        label.textColor = .label
        return label
    }()

    // MARK: - Property
    private let title: String
    private var value: String?

    // MARK: - Initializer
    init(title: String, value: String? = " ") {
        self.title = title
        self.value = value
        super.init(frame: .zero)

        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Functions
    private func setupUI() {
        alignment = .center
        axis = .vertical
        spacing = 9

        addArrangedSubview(valueLabel)
        addArrangedSubview(titleLabel)
    }

    // MARK: - Public Functions
    internal func setValue(_ value: String) {
        self.value = value
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.valueLabel.text = value
        }
    }
}
