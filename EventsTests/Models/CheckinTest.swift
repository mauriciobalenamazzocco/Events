//
//  CheckinTest.swift
//  EventsTests
//
//  Created by Mauricio Balena Mazzocco on 01/09/20.
//  Copyright © 2020 Mauricio Mazzocco. All rights reserved.
//

import Foundation
@testable import Events
import XCTest

class CheckinTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }


    func testEquals_Checkin() {
        let checkin1 = Checkin(eventId: "1", name: "name", email: "email")
        let checkin2 = Checkin(eventId: "1", name: "name", email: "email")

        XCTAssertEqual(checkin1, checkin2)
    }
}
