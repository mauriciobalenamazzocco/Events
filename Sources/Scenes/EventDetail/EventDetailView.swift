import UIKit
import RxCocoa
import RxSwift
import SDWebImage

// swiftlint:disable private_outlet
class EventDetailView: UIView {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var checkinButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension EventDetailView: ClassIdentifiable, NibIdentifiable {}
