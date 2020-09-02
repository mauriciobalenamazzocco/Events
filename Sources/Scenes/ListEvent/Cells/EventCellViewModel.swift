import Foundation
import RxSwift
import RxCocoa
import XCoordinator

class EventCellViewModel: CellViewModelProtocol {
    private var disposeBag = DisposeBag()
    private let title: String?
    private var date: String?
    private var picture: URL?
    private let price: Double?
    private let description: String?
    private let eventId: String?
    private let _eventRegistred = PublishRelay<Void>()
    private let broadcast: EventBroadcastProtocol

    var eventRegistred: Driver<Void> // Only to simulate register

    init(event: Occurrence,
         broadcast: EventBroadcastProtocol = EventBroadcast.shared) {
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
    }

    func transform(input: EventCellViewModel.Input) -> EventCellViewModel.Output {
        let formatPrice = "R$ \(price ?? 0)"

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
extension EventCellViewModel {
    struct Input { }

    struct Output {
        let picture: Driver<URL?>
        let title: Driver<String?>
        let price: Driver<String?>
        let description: Driver<String?>
        let date: Driver<String?>
        let eventRegistred: Driver<Void>
    }
}
