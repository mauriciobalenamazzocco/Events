import Foundation
import RxSwift
import SpinCommon
import SpinRxSwift

class ListFeature<T> {
    let spin: UISpin<ListFeature<T>.State, ListFeature<T>.Event>
    init(spin: RxSpin<ListFeature<T>.State, ListFeature<T>.Event>) {
        self.spin = UISpin(spin: spin)
    }
}

// MARK: - State
extension ListFeature {
    enum State {
        case idle
        case refreshing(filter: String, initial: Bool) //Used filter make a search
        case refreshed(ListPage<T>)
        case loadingPage(page: UInt, filter: String)
        case loadedPage(ListPage<T>)
        case error(Error)
        case empty
    }
    enum Event {
        case refresh(filter: String, initial: Bool)
        case refreshed(ListPage<T>)
        case loadPage(page: UInt, filter: String)  //Used filter make a search
        case pageLoaded(ListPage<T>)
        case errored(Error)
    }
}

// MARK: - Reducer
extension ListFeature {
    static func reduce(state: ListFeature<T>.State, event: ListFeature<T>.Event) -> ListFeature<T>.State {
        switch (state, event) {
        case let (_, .refresh(filter, initial)):
            return .refreshing(filter: filter, initial: initial)

        case (.refreshing, .refreshed(let items)):
            if items.items.isEmpty {
                return .empty
            } else {
                return .refreshed(items)
            }

        case let (_, .loadPage(page, filter)):
            return .loadingPage(page: page, filter: filter)

        case (.loadingPage, .pageLoaded(let items)):
            return .loadedPage(items)

        case let (_, .errored(error)):
            return .error(error)

        default:
            return state
        }
    }
}
