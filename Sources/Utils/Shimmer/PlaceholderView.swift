import UIKit

class PlaceholderView: UIView {

    private var animating: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if animating {
            for n in 0...subviews.count - 1 {
                self.subviews[n].shimmer(with: 1)
            }
        }
    }

    deinit {
        for n in 0...subviews.count - 1 {
            self.subviews[n].stopShimmering()
        }
    }

    func animate() {
        animating = true
        for n in 0...subviews.count - 1 {
            self.subviews[n].shimmer(with: 1)
        }

    }
}
