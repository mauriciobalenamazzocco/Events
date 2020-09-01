import Foundation
import RxSwift
import SpinCommon
import SpinRxSwift

class ListEventFeature: ListFeature<Occurrence> {
    typealias ListFeatureType = ListFeature<Occurrence>

    init(eventApi: EventAPIProtocol = EventAPI()) {
        let refresh = partial(ListEventFeature.refresh, arg1: eventApi, arg2: .partial)
        let loadPage = partial(ListEventFeature.loadPage, arg1: eventApi, arg2: .partial)

        let spinner = Spinner
            .initialState(ListFeatureType.State.idle)
            .feedback(Feedback(effect: refresh))
            .feedback(Feedback(effect: loadPage))
            .reducer(Reducer(ListFeatureType.reduce))

        super.init(spin: spinner)
    }

    static func refresh(eventAPI: EventAPIProtocol,
                        state: ListFeatureType.State) -> Observable<ListFeatureType.Event> {
        guard case .refreshing(_, _) = state else { return .empty() }

        return Single.create { single in

            eventAPI.fetchAllEvents(url: EventAPI.apiEventPath) { result in
                switch result {
                case let .success(events):
                    let listPage = ListPage<Occurrence>.first(items: events, hasNext: false)
                    single(.success(.refreshed(listPage)))
                case let .failure(error):
                    single(.success(.errored(error)))
                }
            }
            return Disposables.create()
        }.asObservable()
    }

    static func loadPage(eventAPI: EventAPIProtocol,
                         state: ListFeatureType.State) -> Observable<ListFeatureType.Event> {
        guard case .loadingPage(_, _) = state else { return .empty() } //Used to pagination and Filter, but this api cant do a pagination

        return Single.create { single in

            eventAPI.fetchAllEvents(url: EventAPI.apiEventPath) { result in
                switch result {
                case let .success(events):
                    let listPage = ListPage<Occurrence>.first(items: events, hasNext: false)
                    single(.success(.pageLoaded(listPage)))
                case let .failure(error):
                    single(.success(.errored(error)))
                }
            }
            return Disposables.create()
        }.asObservable()

    }
}
