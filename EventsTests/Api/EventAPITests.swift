
import Foundation

@testable import Events
import XCTest

class EventAPITests: XCTestCase
{
    // MARK: - Subject under test

    var eventAPIProtocol: EventAPIProtocol!

    //MARK: - Mocks

    func getEventListJsonMock() -> Data {
        let testBundle = Bundle(for: type(of: self))
        guard let filePath = testBundle.path(forResource: "EventsJsonMock", ofType: "txt")
            else { fatalError() }
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        return jsonData
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

    func test_FetchEventsShouldReturnListOfEvents()
    {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = getEventListJsonMock()

        // When

        eventAPIProtocol = EventAPI(urlSession: urlSessionMock)

        var ocurrenceList: [Occurrence] = []

        let expect = expectation(description: "Wait for fetchEvents to return")

        eventAPIProtocol.fetchAllEvents(url: "fakeURl") { result in
            switch result {
            case .success(let ocurrences):
                ocurrenceList = ocurrences

            case .failure( _): break
            }

            expect.fulfill()
        }

        waitForExpectations(timeout: 1)

        // Then

        XCTAssertEqual(ocurrenceList.count, 3, "fetchEvents() should return a list of event")
    }

    func test_FetchEventsShouldReturnApiError()
    {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.error = NSError(domain: "Error 404", code: 404, userInfo: [:])

        //When
        eventAPIProtocol =  EventAPI(urlSession: urlSessionMock)

        var serviceErrorResult: ServiceError!
        let expect = expectation(description: "Wait for fetchEvents() to return")

        eventAPIProtocol.fetchAllEvents(url: "fakeURL") { result in
            switch result {
            case .success( _): break
            case .failure( let error ):
                serviceErrorResult = error
                expect.fulfill()
            }
        }

        waitForExpectations(timeout: 1.2)

        // Then
        XCTAssertEqual(.api(NSError(domain: "Error 404", code: 404, userInfo: [:])), serviceErrorResult, "Test error is the same type")
    }

    func test_fetchEventsShouldReturnParseError()
    {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = Data()
        // When

        eventAPIProtocol =  EventAPI(urlSession: urlSessionMock)


        var serviceErrorResult: ServiceError!
        let expect = expectation(description: "Wait for fetchEvents() to return")

        eventAPIProtocol.fetchAllEvents(url: "fakeURl") { result in
            switch result {
            case .success( _): break
            case .failure( let error ):
                serviceErrorResult = error
                expect.fulfill()
            }
        }

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(.parse, serviceErrorResult, "Test error is the same type")
    }


    func test_FetchEventDetailShouldReturnEventDetail()
    {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = getEventJsonMock()

        // When

        eventAPIProtocol = EventAPI(urlSession: urlSessionMock)

        var eventTest: Occurrence?

        let expect = expectation(description: "Wait for fetchEventDetail to return")

        eventAPIProtocol.fetchEventDetail(url: "fakeURl") { result in
            switch result {
            case .success(let ocurrence):
                eventTest = ocurrence
            case .failure( _): break
            }

            expect.fulfill()
        }

        waitForExpectations(timeout: 1.2)

        // Then

        XCTAssert(eventTest != nil, "fetchEventDetail() should return event" )
    }

    func test_FetchEventDetailShouldReturnApiError()
    {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.error = NSError(domain: "Error 404", code: 404, userInfo: [:])

        //When
        eventAPIProtocol =  EventAPI(urlSession: urlSessionMock)

        var serviceErrorResult: ServiceError!
        let expect = expectation(description: "Wait for fetchEventDetail() to return")

        eventAPIProtocol.fetchEventDetail(url: "fakeURL") { result in
            switch result {
            case .success( _): break
            case .failure( let error ):
                serviceErrorResult = error
                expect.fulfill()
            }
        }

        waitForExpectations(timeout: 1.2)

        // Then
        XCTAssertEqual(.api(NSError(domain: "Error 404", code: 404, userInfo: [:])), serviceErrorResult, "Test error is the same type")
    }

    func test_fetchEventDetailShouldReturnParseError()
    {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = Data()

        // When

        eventAPIProtocol =  EventAPI(urlSession: urlSessionMock)

        var serviceErrorResult: ServiceError!
        let expect = expectation(description: "Wait for fetchEventDetail() to return")

        eventAPIProtocol.fetchEventDetail(url: "fakeURl") { result in
            switch result {
            case .success( _): break
            case .failure( let error ):
                serviceErrorResult = error
                expect.fulfill()
            }
        }

        waitForExpectations(timeout: 1.2)

        // Then
        XCTAssertEqual(.parse, serviceErrorResult, "Test error is the same type")

    }
}
