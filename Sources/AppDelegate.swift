import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Stored properties

    private lazy var mainWindow = UIWindow()
    private let router = EventCoordinator().strongRouter

    // MARK: UIApplicationDelegate
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureUI()
        router.setRoot(for: mainWindow)
        return true
    }

    // MARK: Helpers

    private func configureUI() {
        UIView.appearance().overrideUserInterfaceStyle = .light
    }

}
