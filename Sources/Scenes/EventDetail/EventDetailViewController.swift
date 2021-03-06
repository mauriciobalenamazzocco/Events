import Foundation
import UIKit
import RxCocoa
import RxSwift
import SDWebImage
import VanillaConstraints

class EventDetailViewController: UIViewController, BindableType {
    typealias ViewModelType = EventDetailViewModel
    var viewModel: ViewModelType!

    var disposeBag = DisposeBag()

    internal lazy var eventDetailView: EventDetailView = {
        return EventDetailView.initFromNib()
    }()

    private lazy var picture = Binder<URL?>(eventDetailView) { eventDetailView, url in
        eventDetailView.pictureImageView.sd_setImage(
            with: url,
            placeholderImage: R.image.eventDefault(),
            options: [.refreshCached],
            completed: nil
        )
    }

    private lazy var eventRegistred = Binder<Void>(eventDetailView) { eventDetailView, _ in
        eventDetailView.priceLabel.isHidden = true
        eventDetailView.checkinButton.isEnabled = false
        eventDetailView.checkinButton.backgroundColor = .lightGray
        eventDetailView.checkinButton.setTitle(R.string.localizable.registred(), for: .normal)
        eventDetailView.checkinButton.layer.cornerRadius = 10
    }

    override func loadView() {
        view = eventDetailView
    }

    func bindViewModel() {

        let outputs = viewModel.transform(input:
            .init(
                openCheckin: eventDetailView.checkinButton.rx.tap.asDriver())
        )

        outputs.date
            .drive(eventDetailView.dateLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.description
            .drive(eventDetailView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.picture
            .drive(picture)
            .disposed(by: disposeBag)

        outputs.price
            .drive(eventDetailView.priceLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.title
            .drive(eventDetailView.titleLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.title
                   .drive(navigationItem.rx.title)
                   .disposed(by: disposeBag)

        outputs.eventRegistred
        .drive(eventRegistred)
        .disposed(by: disposeBag)
    }
}
