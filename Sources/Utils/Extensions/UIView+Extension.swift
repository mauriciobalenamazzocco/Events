import UIKit

extension UIView {
    func shimmer(with time: CFTimeInterval = 1) {
        subviews.forEach { [weak self] subview in
            guard let self = self else { return }

            subview.layer.mask?.removeAllAnimations()

            let transparency: CGFloat = 0.5
            let gradientWidth: CGFloat = 80.0

            let gradientMask = CAGradientLayer()
            gradientMask.frame = CGRect(x: -subview.frame.origin.x, y: 0, width: self.bounds.width, height: subview.frame.height)

            let gradientSize = gradientWidth / self.bounds.width
            let gradientColor = UIColor(white: 1, alpha: transparency)
            let startLocations = [0, gradientSize / 2, gradientSize]
            let endLocations = [(1 - gradientSize), (1 - gradientSize / 2), 1]
            let animation = CABasicAnimation(keyPath: "locations")

            gradientMask.colors = [gradientColor.cgColor, UIColor.white.cgColor, gradientColor.cgColor]
            gradientMask.locations = startLocations as [NSNumber]?
            gradientMask.startPoint = CGPoint(x: 0 - (gradientSize * 2), y: 0.5)
            gradientMask.endPoint = CGPoint(x: 1 + gradientSize, y: 0.5)

            subview.layer.mask = gradientMask

            animation.fromValue = startLocations
            animation.toValue = endLocations
            animation.repeatCount = HUGE
            animation.duration = time

            gradientMask.add(animation, forKey: nil)
        }
    }

    func stopShimmering() {
        subviews
            .compactMap { $0.layer.mask }
            .forEach { $0.removeAllAnimations() }
    }
}
