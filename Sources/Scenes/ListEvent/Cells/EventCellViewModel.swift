import Foundation
import RxSwift
import RxCocoa
import XCoordinator

class EventCellViewModel: CellViewModelProtocol {
    private var disposeBag = DisposeBag()

    //
    private let title: String?
    private let id: String?
    private var date: String?
    private var picture: URL?
    private let price: Double?
    private let description: String?

    init(event: Occurrence) {
        title = event.title
        id = event.id
        price = event.price
        description = event.description
        if let timestamp = event.date {
            date = Date(timeIntervalSince1970: timestamp).formattedString
        }

        if let image = event.image,
            let url = URL(string: image) {
            picture = url
        }
    }

    func transform(input: EventCellViewModel.Input) -> EventCellViewModel.Output {
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
extension EventCellViewModel {
    struct Input {
      //  var changeState: Observable<Void>
    }
    struct Output {
        let picture: Driver<URL?>
        let title: Driver<String?>
        let price: Driver<String?>
        let description: Driver<String?>
        let date: Driver<String?>
    }
}
