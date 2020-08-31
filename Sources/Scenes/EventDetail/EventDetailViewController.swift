import Foundation
import UIKit
import RxCocoa
import RxSwift
import SDWebImage
import VanillaConstraints

class EventDetailViewController: UIViewController, BindableType {
    typealias ViewModelType = EventDetailViewModel
    var viewModel: ViewModelType!

    @IBOutlet private var eventDetailView: EventDetailView!

    var disposeBag = DisposeBag()

    private lazy var picture = Binder<URL?>(eventDetailView) { imageView, url in
        self.eventDetailView.pictureImageView.sd_setImage(
            with: url,
            placeholderImage: R.image.eventDefault(),
            options: [.refreshCached],
            completed: nil
        )
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
    }

}
