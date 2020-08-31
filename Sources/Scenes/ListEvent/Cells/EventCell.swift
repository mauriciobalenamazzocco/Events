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

    typealias ViewModelType = EventCellViewModel
     var viewModel: ViewModelType!

     var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        pictureImageView.styleRounded()
    }

    private lazy var picture = Binder<URL?>(pictureImageView) { imageView, url in
        imageView.sd_setImage(
            with: url,
            placeholderImage: R.image.eventDefault(),
            options: [.refreshCached],
            completed: nil
        )
    }

    override func prepareForReuse() {
          super.prepareForReuse()
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
      }
}

extension EventCell: ClassIdentifiable, NibIdentifiable {}
