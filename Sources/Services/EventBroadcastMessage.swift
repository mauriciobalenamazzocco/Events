import Foundation

import RxSwift

//Fake Event Registred on server this will only show one time register 
enum EventBroadcastMessage: Equatable {
    case eventRegistred(id: String)
}

protocol EventBroadcastProtocol {
    var onMessage: Observable<EventBroadcastMessage> { get }
    func broadcast(message: EventBroadcastMessage)
}

struct EventBroadcast: EventBroadcastProtocol {
    static let shared = EventBroadcast() // Not the best way but only to show event registred, simulating APi registred

    let onMessage: Observable<EventBroadcastMessage>

    private let _onMessage = PublishSubject<EventBroadcastMessage>()

    init() {
        onMessage = _onMessage.asObservable()
    }

    func broadcast(message: EventBroadcastMessage) {
        _onMessage.onNext(message)
    }
}
