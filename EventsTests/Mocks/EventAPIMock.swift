//
//  EventAPIMock.swift
//  EventsTests
//
//  Created by Mauricio Balena Mazzocco on 01/09/20.
//  Copyright © 2020 Mauricio Mazzocco. All rights reserved.
//

import Foundation


@testable import Events

class EventAPIMock: EventAPIProtocol {

    var eventsReturnValue: EventsResponse!
    var eventReturnValue: EventResponse!

    func fetchAllEvents(url: String, completionHandler: @escaping (EventsResponse) -> Void) {
        completionHandler(eventsReturnValue)
    }

    func fetchEventDetail(url: String, completionHandler: @escaping (EventResponse) -> Void) {
        completionHandler(eventReturnValue)
    }
}
