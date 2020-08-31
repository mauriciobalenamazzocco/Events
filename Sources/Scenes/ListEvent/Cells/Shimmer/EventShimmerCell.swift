import UIKit

class EventShimmerCell: PlaceholderCell {
    @IBOutlet weak var shimmerContainer: UIView!
    @IBOutlet weak var roundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        roundView.layer.cornerRadius = roundView.frame.width / 2
        startShimmer()
    }
}

// MARK: - ClassIdenfiable + NibIdenfiable
extension EventShimmerCell: ClassIdentifiable, NibIdentifiable {}
