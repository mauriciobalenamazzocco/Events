import UIKit
import RxSwift
import RxCocoa
import VanillaConstraints

extension StatusBackgroundView: HasDelegate {
    typealias Delegate = StatusBackgroundViewDelegate
}

class StatusBackgroundViewDelegateProxy: DelegateProxy<StatusBackgroundView, StatusBackgroundViewDelegate>,
                                         DelegateProxyType,
                                         StatusBackgroundViewDelegate {

    let didTapSubject = PublishSubject<Void>()

    init(backgroundView: StatusBackgroundView) {
        super.init(parentObject: backgroundView, delegateProxy: StatusBackgroundViewDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { StatusBackgroundViewDelegateProxy(backgroundView: $0) }
    }

    func didTapErrorViewButton() {
        didTapSubject.onNext(())
    }

    deinit {
        didTapSubject.onCompleted()
    }
}

extension Reactive where Base: StatusBackgroundView {
    var delegate: StatusBackgroundViewDelegateProxy {
        return StatusBackgroundViewDelegateProxy.proxy(for: base)
    }

    var didTapActionButton: Driver<Void> {
        return delegate.didTapSubject.asDriver(onErrorJustReturn: ())
    }
}

protocol StatusBackgroundViewDelegate: class {
    func didTapErrorViewButton()
}

class StatusBackgroundView: UIView {
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
         label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = R.color.subtitle()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = R.color.title()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor =  R.color.primaryColor()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.layer.cornerRadius = 4.0
        return button
    }()
    private lazy var containerLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(topImageView)
        stackView.addArrangedSubview(containerLabelStackView)
        stackView.addArrangedSubview(button)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    weak var delegate: StatusBackgroundViewDelegate?
    var buttonAction: (() -> Void)?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initElements()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initElements()
    }

    func update(topImage: UIImage, title: String, subtitle: String, buttonDescription: String, alpha: CGFloat = 1.0) {
        topImageView.image = topImage
        titleLabel.text = title
        subtitleLabel.text = subtitle
        topImageView.alpha = alpha
        button.setTitle(buttonDescription, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        titleLabel.isHidden = title.isEmpty
        button.isHidden = buttonDescription.isEmpty
    }

// MARK: - StatusBackgroundViewDelegate
    @objc
    private func buttonTapped() {
        buttonAction?()
        delegate?.didTapErrorViewButton()
    }
}

// MARK: - Constraints
extension StatusBackgroundView {
    private func initElements() {
        topImageView
            .height(120)
            .width(120)

        containerStackView
            .add(to: self)
            .centerX(to: \.centerXAnchor)
            .centerY(to: \.centerYAnchor, constant: -UIScreen.main.bounds.height * 0.1)
            .leading(to: \.leadingAnchor, constant: 32)
            .trailing(to: \.trailingAnchor, constant: 32)
    }
}
