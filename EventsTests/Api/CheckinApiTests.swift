//
//  CheckinApiTests.swift
//  EventsTests
//
//  Created by Mauricio Balena Mazzocco on 01/09/20.
//  Copyright © 2020 Mauricio Mazzocco. All rights reserved.
//

import Foundation
@testable import Events
import XCTest

class CheckinAPITests: XCTestCase
{
    // MARK: - Subject under test

    var checkinAPIProtocol: CheckinAPIProtocol!

    //MARK: - Mocks

    func getCheckinInputMock() -> Checkin {
        return Checkin(eventId: "1", name: "Mauricio", email: "email@123")

    }

    func getCheckinOutputMockasData(checkinResponse: CheckinResponse) -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let jsonData = try? encoder.encode(checkinResponse) {
            return jsonData
        }

        return Data()
    }

    func getEventJsonMock() -> Data {
        let testBundle = Bundle(for: type(of: self))
        guard let filePath = testBundle.path(forResource: "EventJsonMock", ofType: "txt")
            else { fatalError() }
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        return jsonData
    }

    // MARK: - Test lifecycle

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    class URLSessionDataTaskSpy: URLSessionDataTask {
        var cancelCalled = false
        var resumeCalled = false
        override init () {}

        override func cancel() {
            cancelCalled = true
        }

        override func resume() {
            resumeCalled = true
        }
    }



    class URLSessionMock: URLSessionProtocol {
        var data: Data?
        var error: Error?
        var urlResponse: URLResponse?

        func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            completionHandler(data, urlResponse, error)
            return  URLSessionDataTaskSpy()
        }
    }

    // MARK: - Test

    func test_CheckinShouldPass()
    {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = getCheckinOutputMockasData(checkinResponse: CheckinResponse(code: "200"))

        // When

        checkinAPIProtocol = CheckinAPI(urlSession: urlSessionMock)

        let checkinMock = getCheckinInputMock()

        let expect = expectation(description: "Wait for fetchEvents to return")

        checkinAPIProtocol.checkin(
            url: "fakeUrl",
            id: checkinMock.eventId,
            email: checkinMock.email,
            name: checkinMock.name){ result in

                switch result {
                case .success:
                    expect.fulfill()
                    break
                case .failure( _): break
                }
        }

        waitForExpectations(timeout: 1)

        // Then

        XCTAssert(true)
    }


    func test_CheckinShouldReturnCheckinResponseParseError()
    {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = Data()

        // When
        let checkinMock = getCheckinInputMock()

        checkinAPIProtocol = CheckinAPI(urlSession: urlSessionMock)

        var serviceErrorResult: ServiceError!

        let expect = expectation(description: "Wait for fetchEvents to return")

        checkinAPIProtocol.checkin(
            url: "fakeUrl",
            id: checkinMock.eventId,
            email: checkinMock.email,
            name: checkinMock.name){ result in

                switch result {
                case .success: break
                case .failure( let error ):
                    serviceErrorResult = error
                    expect.fulfill()
                }
        }

        waitForExpectations(timeout: 1)

        // Then
          XCTAssertEqual(.parse, serviceErrorResult, "Test error is the same type")
    }


    func test_CheckinShouldReturnApiError()
    {
        // Given
        let urlSessionMock = URLSessionMock()
         urlSessionMock.error = NSError(domain: "Error 404", code: 404, userInfo: [:])

        // When
        let checkinMock = getCheckinInputMock()

        checkinAPIProtocol = CheckinAPI(urlSession: urlSessionMock)

        var serviceErrorResult: ServiceError!

        let expect = expectation(description: "Wait for fetchEvents to return")

        checkinAPIProtocol.checkin(
            url: "fakeUrl",
            id: checkinMock.eventId,
            email: checkinMock.email,
            name: checkinMock.name){ result in

                switch result {
                case .success: break
                case .failure( let error ):
                    serviceErrorResult = error
                    expect.fulfill()
                }
        }

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(.api(NSError(domain: "Error 404", code: 404, userInfo: [:])), serviceErrorResult, "Test error is the same type")
    }

    func test_CheckinShouldReturnUnauthorizedError()
    {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = getCheckinOutputMockasData(checkinResponse: CheckinResponse(code: "999"))

        // When
        let checkinMock = getCheckinInputMock()

        checkinAPIProtocol = CheckinAPI(urlSession: urlSessionMock)

        var serviceErrorResult: ServiceError!

        let expect = expectation(description: "Wait for fetchEvents to return")

        checkinAPIProtocol.checkin(
            url: "fakeUrl",
            id: checkinMock.eventId,
            email: checkinMock.email,
            name: checkinMock.name){ result in

                switch result {
                case .success: break
                case .failure( let error ):
                    serviceErrorResult = error
                    expect.fulfill()
                }
        }

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(.unauthorized, serviceErrorResult, "Test error is the same type")
    }

}
