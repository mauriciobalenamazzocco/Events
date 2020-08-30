import UIKit

protocol StoryboardIdentifiable: class {}

extension StoryboardIdentifiable where Self: UIViewController {
    static func instantiateViewController(storyboardName: String) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self
            else { fatalError("Couldn't find view controller for \(self)") }
        return vc
    }
}
