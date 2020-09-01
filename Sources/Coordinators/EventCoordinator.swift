import Foundation
import XCoordinator

enum EventCoordinatorRoute: Route {
    case events
    case eventDetail(Occurrence)
    case close
    case checkin(
        eventTitle: String?,
        eventPrice: Double?,
        eventDate: String?,
        eventId: String,
        eventPicture: URL?
    )
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

        super.init(rootViewController: navigation)
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
                viewModelFactory: { event in

                    return EventCellViewModel(event: event)
                },
                selectedItem: { [weak self] event in
                    guard let self = self else { return }
                    self.trigger(.eventDetail(event))
                }
            )
            eventList.title = R.string.localizable.events()
            eventList.bind(feature: ListEventFeature())
            return .push(eventList, animation: nil)

        case .eventDetail(let event):
            var eventDetailViewContoller = EventDetailViewController()
            eventDetailViewContoller.bind(to: EventDetailViewModel(event: event, coordinator: self.weakRouter))
            eventDetailViewContoller.navigationItem.largeTitleDisplayMode = .never
              return .push(eventDetailViewContoller)

        case .close:
            return .dismiss()

        case .checkin(
            eventTitle: let eventTitle,
            eventPrice: let eventPrice,
            eventDate: let eventDate,
            eventId: let eventId,
            eventPicture: let eventPicture) :

            var checkinViewControler = CheckinViewController()
            let checkinModel = CheckinViewModel(
                eventTitle: eventTitle,
                eventPrice: eventPrice,
                eventDate: eventDate,
                eventId: eventId,
                eventPicture: eventPicture,
                coordinator: self.weakRouter
            )
            checkinViewControler.bind(to: checkinModel)

            return .present(checkinViewControler)

        }
    }
}
