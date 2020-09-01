import Foundation
import SpinCommon
import SpinRxSwift
import RxSwift
import XCoordinator
import RxCocoa
import SDWebImage

class CheckinViewController: UIViewController, BindableType {
    typealias ViewModelType = CheckinViewModel
    var viewModel: ViewModelType!

      private lazy var checkinView: CheckinView = {
        return CheckinView.initFromNib()
    }()

    var disposeBag = DisposeBag()

    private lazy var picture = Binder<URL?>(checkinView) { checkinView, url in
        checkinView.pictureImageView.sd_setImage(
            with: url,
            placeholderImage: R.image.eventDefault(),
            options: [.refreshCached],
            completed: nil
        )
    }

    override func loadView() {
        view = checkinView

    }

    func bindViewModel() {

        viewModel.spin.render(on: self, using: { $0.render(state:) })
        viewModel.spin.start()

        let outputs = viewModel.transform(input:
            .init(
                checking: checkinView.confirmButton.rx.tap.map { [weak self]_ -> (String?, String?) in
                    return ( self?.checkinView.nameTextField.text, self?.checkinView.emailTextField.text)
                }.asDriver(onErrorDriveWith: .just(("", ""))),
                close: checkinView.closeButton.rx.tap.asDriver()
            )
        )

        outputs.date
            .drive(checkinView.dateLabel.rx.text)
            .disposed(by: disposeBag)


        outputs.picture
            .drive(picture)
            .disposed(by: disposeBag)

        outputs.price
            .drive(checkinView.priceLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.title
            .drive(checkinView.titleLabel.rx.text)
            .disposed(by: disposeBag)

        checkinView.nameTextField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.checkinView.nameTextField.placeHolderColor = .lightGray
                self?.checkinView.nameTextField.textColor = .lightGray
            }).disposed(by: disposeBag)

        checkinView.emailTextField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.checkinView.emailTextField.placeHolderColor = .lightGray
                self?.checkinView.emailTextField.textColor = .lightGray
            }).disposed(by: disposeBag)

    }
}

extension CheckinViewController {
    private func render(state: CheckinViewModel.State) {
        switch state {

        case .idle:
             break
        case .registering(_, _):
            checkinView.confirmButton.animate(animation: .collapse)
        case let .error(error):
            switch error {
            case .parse:
                print("Parse Error")
            case .urlInvalid:
                print("Parse Error")
            case .api(let error):
                print("Parse Error")
            }
             print("Error")
        case .registred:
            viewModel.coordinator.trigger(.close)
        case .securityFail(name: let name, email: let email):
            checkinView.nameTextField.placeHolderColor = !name ? .red : .lightGray
            checkinView.emailTextField.placeHolderColor = !email ? .red :.lightGray
            checkinView.nameTextField.textColor = !name ? .red : .lightGray
            checkinView.emailTextField.textColor = !email ? .red : .lightGray
            checkinView.confirmButton.animate(animation: .shake)
        }
    }
}