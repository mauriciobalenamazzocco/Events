import Foundation
import XCoordinator
import SpinCommon
import SpinRxSwift
import RxSwift
import RxCocoa

class EventDetailViewModel: ViewModelProtocol {
    private var disposeBag = DisposeBag()
    private let title: String?
    private var date: String?
    private var picture: URL?
    private let price: Double?
    private let description: String?
    private let eventId: String?
    private let coordinator: WeakRouter<EventCoordinatorRoute>
    private let broadcast: EventBroadcastProtocol
    private let _eventRegistred = PublishRelay<Void>()

    var eventRegistred: Driver<Void>

    init(event: Occurrence,
         coordinator: WeakRouter<EventCoordinatorRoute>,
         broadcast: EventBroadcastProtocol = EventBroadcast.shared) {
        self.coordinator = coordinator
        title = event.title
        price = event.price
        description = event.description
        eventId = event.id
        self.broadcast = broadcast

        if let timestamp = event.date {
            date = timestamp.getDateStringFromUnixTime()
        }

        if let image = event.image,
            let url = URL(string: image) {
            picture = url
        }

        eventRegistred = _eventRegistred.asDriver(
                  onErrorRecover: { _ in
                      .empty()
                  }
              )

        broadcast.onMessage
            .subscribe(onNext: { type in
                switch type {
                case .eventRegistred(id: let id):
                    if self.eventId == id {
                        self._eventRegistred.accept(Void())
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func transform(input: EventDetailViewModel.Input) -> EventDetailViewModel.Output {
        input.openCheckin.drive(onNext: { [weak self ]_ in

            if let eventId = self?.eventId {
                self?.coordinator.trigger(
                    .checkin(eventTitle: self?.title,
                             eventPrice: self?.price,
                             eventDate: self?.date,
                             eventId: eventId,
                             eventPicture: self?.picture))
            }
        }).disposed(by: disposeBag)

        let formatPrice = "R$ \(price ?? 0)"
        return Output(
            picture: .just(picture),
            title: .just(title),
            price: .just(formatPrice),
            description: .just(description),
            date: .just(date),
            eventRegistred: eventRegistred
        )
    }

    func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}

// MARK: - ViewModelProtocol
extension EventDetailViewModel {
    struct Input {
       var openCheckin: Driver<Void>
    }
    struct Output {
        let picture: Driver<URL?>
        let title: Driver<String?>
        let price: Driver<String?>
        let description: Driver<String?>
        let date: Driver<String?>
        let eventRegistred: Driver<Void>
    }
}
