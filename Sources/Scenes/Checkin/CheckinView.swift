import Foundation
import UIKit
import EMSpinnerButton
class CheckinView: UIView {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var confirmButton: EMSpinnerButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        pictureImageView.styleRounded()
        confirmButton.backgroundColor = R.color.primaryColor()
        confirmButton.spinnerColor = UIColor.white.cgColor
        confirmButton.cornerRadius = 10
    }
}

extension CheckinView: ClassIdentifiable, NibIdentifiable {}
