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

    init(event: Occurrence) {
        title = event.title
        price = event.price
        description = event.description
        if let timestamp = event.date {
            date = timestamp.getDateStringFromUnixTime()
        }

        if let image = event.image,
            let url = URL(string: image) {
            picture = url
        }
    }

    func transform(input: EventDetailViewModel.Input) -> EventDetailViewModel.Output {
        input.openCheckin.drive(onNext: { _ in

        }).disposed(by: disposeBag)

        let formatPrice = "R$ \(price ?? 0)"
        return Output(
            picture: .just(picture),
            title: .just(title),
            price: .just(formatPrice),
            description: .just(description),
            date: .just(date)
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
    }
}
