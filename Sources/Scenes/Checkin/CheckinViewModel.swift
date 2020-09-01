import Foundation
import SpinCommon
import SpinRxSwift
import RxSwift
import XCoordinator
import RxCocoa

class CheckinViewModel {
    let spin: UISpin<State, Event>
    let coordinator: WeakRouter<EventCoordinatorRoute>

    private let eventTitle: String?
    private let eventPrice: Double?
    private let eventDate: String?
    private let eventPicture: URL?
    private let eventId: String?

    private var disposeBag = DisposeBag()

    init(eventTitle: String?,
         eventPrice: Double?,
         eventDate: String?,
         eventId: String,
         eventPicture: URL?,
         checkinAPI: CheckinAPIProtocol = CheckinAPI(),
         coordinator: WeakRouter<EventCoordinatorRoute>,
         broadcaster: EventBroadcastProtocol = EventBroadcast.shared) {

        self.eventTitle = eventTitle
        self.eventId = eventId
        self.eventDate = eventDate
        self.eventPrice = eventPrice
        self.eventPicture = eventPicture
        self.coordinator = coordinator

        let register = partial(CheckinViewModel.register,
                               arg1: eventId,
                               arg2: checkinAPI,
                               arg3: broadcaster,
                               arg4: .partial)

        let spinner = Spinner
            .initialState(CheckinViewModel.State.idle)
            .feedback(Feedback(effect: register))
            .reducer(Reducer(CheckinViewModel.reduce))

            spin = UISpin(spin: spinner)
    }

    func transform(input: CheckinViewModel.Input) -> CheckinViewModel.Output {
        input.close.drive(onNext: { [weak self]_ in
            self?.coordinator.trigger(.close)
        }).disposed(by: disposeBag)

        input.checking.drive(onNext: {[weak self] (name, email) in

            if let name = name, let email = email {
                let checkName = name.validateName()
                let checkEmail = email.validateEmail()

                if checkName && checkEmail {
                    self?.spin.emit(.register(name, email))
                } else {
                    self?.spin.emit(.didSecurityFail(name: checkName, email: checkEmail))
                }
            }
        }).disposed(by: disposeBag)

        let formatPrice = "R$ \(eventPrice != nil ? eventPrice! : 0)"

        return Output(
            picture: .just(eventPicture),
            title: .just(eventTitle ?? ""),
            price: .just(formatPrice),
            date: .just(eventDate ?? "")
        )
    }
}

// MARK: - ViewModelProtocol
extension CheckinViewModel {
    struct Input {
        var checking: Driver<(name: String?, email: String?)>
        var close: Driver<Void>
    }
    struct Output {
        let picture: Driver<URL?>
        let title: Driver<String>
        let price: Driver<String>
        let date: Driver<String>
    }
}

extension CheckinViewModel {
    static func register(eventId: String,
                         checkinAPI: CheckinAPIProtocol,
                         broadcast: EventBroadcastProtocol,
                         state: CheckinViewModel.State) -> Observable<CheckinViewModel.Event> {
        guard case let .registering(email, name) = state else { return .empty() }

        return Single.create { single in

            checkinAPI.checkin(url: CheckinAPI.checkinPath, id: eventId, email: email, name: name) { result in
                switch result {
                case  .success:
                    broadcast.broadcast(message: .eventRegistred(id: eventId))
                    single(.success(.didRegister))
                case let .failure(error):
                    single(.success(.didFail(error)))
                }
            }
            return Disposables.create()
        }.asObservable()
    }
}

// MARK: - State machine
extension CheckinViewModel {
    enum State {
        case idle
        case registering(String, String)
        case error(ServiceError)
        case registred
        case securityFail(name: Bool, email: Bool)
    }
    enum Event {
        case register(String, String)
        case didFail(ServiceError)
        case didRegister
        case didSecurityFail(name: Bool, email: Bool)
    }

    static func reduce(state: State, event: Event) -> State {
        switch (state, event) {
        case let(_, .register(email, nome)):
            return .registering(email, nome)
        case (.registering, .didRegister):
            return .registred
        case let (_, .didFail(error)):
            return .error(error)
        case let (_, .didSecurityFail(name, email)):
            return .securityFail(name: name, email: email)
        default:
            return state
        }
    }
}
