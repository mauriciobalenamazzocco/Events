import UIKit
import Foundation

extension UIImageView {
    func styleRounded() {
        layer.masksToBounds = false
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        contentMode = .scaleToFill
    }
}
