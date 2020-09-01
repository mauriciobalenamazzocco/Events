import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class EventCell: UITableViewCell, BindableType {
    @IBOutlet private weak var pictureImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var registredLabel: UILabel!

    typealias ViewModelType = EventCellViewModel
     var viewModel: ViewModelType!

     var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        pictureImageView.styleRounded()
        registredLabel.isHidden = true
    }

    private lazy var picture = Binder<URL?>(pictureImageView) { imageView, url in
        imageView.sd_setImage(
            with: url,
            placeholderImage: R.image.eventDefault(),
            options: [.refreshCached],
            completed: nil
        )
    }

    private lazy var eventRegistred = Binder<Void>(self) { strongSelf, _ in
        strongSelf.priceLabel.isHidden = true
        strongSelf.registredLabel.isHidden = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        registredLabel.isHidden = true
        disposeBag = DisposeBag()
        viewModel.prepareForReuse()
        pictureImageView.sd_cancelCurrentImageLoad()
    }

    
    func bindViewModel() {
          let outputs = viewModel.transform(input:
              .init(

              )
          )
        outputs.date
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.description
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.picture
            .drive(picture)
            .disposed(by: disposeBag)

        outputs.price
            .drive(priceLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.eventRegistred
            .drive(eventRegistred)
            .disposed(by: disposeBag)
      }
}

extension EventCell: ClassIdentifiable, NibIdentifiable {}
