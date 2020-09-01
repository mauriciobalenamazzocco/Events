//
//  CheckinAPIMock.swift
//  EventsTests
//
//  Created by Mauricio Balena Mazzocco on 01/09/20.
//  Copyright © 2020 Mauricio Mazzocco. All rights reserved.
//

import Foundation

@testable import Events

class CheckinAPIMock: CheckinAPIProtocol {

    var checkinReturnValue: CheckinResult!
    func checkin(url: String, id: String, email: String, name: String, completionHandler: @escaping (CheckinResult) -> Void) {
        completionHandler(checkinReturnValue)
    }

}
