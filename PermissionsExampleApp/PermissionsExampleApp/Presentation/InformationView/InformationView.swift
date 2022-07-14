//
//  InformationView.swift
//  PermissionsExampleApp
//
//  Created by Manu on 14/07/2022.
//

import UIKitHelpers
import UIKit

final class InformationView: UIView {
    private lazy var vStack: UIStackView = .init()
    private lazy var imageView: UIImageView = .init()
    private lazy var titleLabel: UILabel = .init()
    private lazy var descriptionLabel: UILabel = .init()
    private lazy var button: UIButton = .init()

    var buttonAction: UIAction? {
        didSet {
            guard let buttonAction = buttonAction else {
                return
            }

            button.addAction(buttonAction, for: .touchUpInside)
        }
    }

    init() {
        super.init(frame: .zero)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(_ model: InformationViewViewModel) {
        imageView.image = model.image
        imageView.isHidden = model.image == nil
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.title = model.title
        button.configuration?.baseBackgroundColor = .tintColor
    }
}

extension InformationView: ViewSetUpping {
    func setUpView() {
        backgroundColor = .systemBackground
        setUpVStack()
        setUpImageView()
        setUpLabels()
        setUpButton()
    }
}

private extension InformationView {
    enum Constants {
        static let vStackSpacing = 8.0
    }

    func setUpVStack() {
        vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.alignment = .center
        vStack.spacing = Constants.vStackSpacing
        addSubview(vStack)
        vStack.pinEdges(.horizontal, withInsets: .init(top: 0, left: 16, bottom: 0, right: 16))
        vStack.pin(.top, to: .topMargin, of: self, relatedBy: .greaterThanOrEqual)
        vStack.pin(.bottom, to: .bottomMargin, of: self, relatedBy: .lessThanOrEqual)
        vStack.pinCenter(.centerY)
    }

    func setUpImageView() {
        imageView.pinSize(.init(100))
        imageView.contentMode = .scaleAspectFit
        vStack.addArrangedSubview(imageView)
    }

    func setUpLabels() {
        titleLabel.supportDynamicType(size: 16, weight: .bold)
        vStack.addArrangedSubview(titleLabel)
        vStack.setCustomSpacing(4, after: titleLabel)

        descriptionLabel.supportDynamicType(size: 14, weight: .regular)
        vStack.addArrangedSubview(descriptionLabel)
        vStack.setCustomSpacing(16, after: descriptionLabel)
    }

    func setUpButton() {
        vStack.addArrangedSubview(button)
    }
}
