import UIKit

class PlaceholderCell: UITableViewCell {

    private var animating: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if animating {
            contentView.shimmer(with: 1)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stopShimmering()
    }

    deinit {
        contentView.stopShimmering()
    }

    func startShimmer() {
        animating = true
        contentView.shimmer(with: 1)
    }

    func stopShimmer() {
        animating = false
        contentView.stopShimmering()
    }
}
