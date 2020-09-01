import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Stored properties

    private lazy var mainWindow = UIWindow()
    private let router = EventCoordinator().strongRouter

    // MARK: UIApplicationDelegate
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureUI()
        router.trigger(.events)
        router.setRoot(for: mainWindow)
        IQKeyboardManager.shared.enable = true

        return true

    }

    // MARK: Helpers

    private func configureUI() {
        mainWindow.backgroundColor = .white
        UIView.appearance().overrideUserInterfaceStyle = .light
    }

}
