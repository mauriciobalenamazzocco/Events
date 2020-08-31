import Foundation
import XCoordinator

enum EventCoordinatorRoute: Route {
    case events
}

class EventCoordinator: NavigationCoordinator<EventCoordinatorRoute> {
    init() {
        let navigation = UINavigationController()
        navigation.modalPresentationStyle = .fullScreen
        navigation.navigationBar.barStyle = .default
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.barTintColor = R.color.primaryColor()
        navigation.navigationBar.prefersLargeTitles = true
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = R.color.primaryColor()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = .white
            navigation.navigationBar.backgroundColor = R.color.primaryColor()
            navigation.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }

        super.init(rootViewController: navigation, initialRoute: .events)
    }

    override func prepareTransition(for route: EventCoordinatorRoute) -> NavigationTransition {
        switch route {
        case .events:
            let eventList = ListViewController<Occurrence, EventCell, EventShimmerCell>(
                .init(
                    icon: R.image.caution(),
                    title: R.string.localizable.somethingWrong(),
                    subtitle:  R.string.localizable.somethingWrong(),
                    actionDescription: "",
                    actionBlock: nil
                ),
                viewModelFactory: { [weak self] event in
                    guard let self = self else { return nil }
                    return EventCellViewModel(event: event)
                },
                selectedItem: { [weak self] event in
                    guard let self = self else { return }

                }
            )
            eventList.title = "Events"
            eventList.bind(feature: ListEventFeature())
            return .push(eventList, animation: nil)

        }
    }
}
