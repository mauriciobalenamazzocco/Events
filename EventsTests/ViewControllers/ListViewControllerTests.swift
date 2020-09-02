//
//  ListViewControllerTests.swift
//  EventsTests
//
//  Created by Mauricio Balena Mazzocco on 01/09/20.
//  Copyright © 2020 Mauricio Mazzocco. All rights reserved.
//

import Foundation
import XCTest
@testable import Events
import RxSwift
import RxTest

class ListViewControllerTests: XCTestCase
{
    // MARK: - Subject under test

    var listViewController: ListViewController<Occurrence, EventCell, EventShimmerCell>!

    var window: UIWindow!

    // MARK: - Mocks

    var eventAPIMock: EventAPIMock!

    func getEventListJsonMock() -> Data {
        let testBundle = Bundle(for: type(of: self))
        guard let filePath = testBundle.path(forResource: "EventsJsonMock", ofType: "txt")
            else { fatalError() }
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        return jsonData
    }

    // MARK: - Test lifecycle
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        eventAPIMock = EventAPIMock()
        setupListViewController()
    }

    override func tearDown()
    {
        window = nil
        super.tearDown()
    }

    // MARK: - Test setup

    func setupListViewController()
    {
        listViewController = ListViewController<Occurrence, EventCell, EventShimmerCell>(
            .init(
                icon: R.image.caution(),
                title: R.string.localizable.somethingWrong(),
                subtitle:  R.string.localizable.somethingWrong(),
                actionDescription: "",
                actionBlock: nil
            ),
            viewModelFactory: { event in

                return EventCellViewModel(event: event)
        },
            selectedItem: nil
        )
    }

    func loadView()
    {
        window.addSubview(listViewController.view)
        RunLoop.current.run(until: Date())
    }


    func test_ListViewControllerParseError() {
         // Given
        eventAPIMock.eventsReturnValue = .failure(.parse)
        listViewController.bind(feature:ListEventFeature(eventApi: eventAPIMock))

        // When
        let expect = expectation(description: "Wait for state to return")
        
        listViewController.feature.spin.render(on: self, using: { _ in return { state in
            switch state {
            case let .error(error):
                if let err = error as? ServiceError {
                    // Then
                    XCTAssertEqual(err, .parse)
                    expect.fulfill()
                }
            default:
                break
            }
            }
        })
        waitForExpectations(timeout: 1)
    }

    func test_ListViewControllerApiError() {
           // Given
          eventAPIMock.eventsReturnValue = .failure(.api(NSError(domain: "Domain", code: 999, userInfo: nil)))
          listViewController.bind(feature:ListEventFeature(eventApi: eventAPIMock))

          // When
          let expect = expectation(description: "Wait for state to return")

          listViewController.feature.spin.render(on: self, using: { _ in return { state in
              switch state {
              case let .error(error):
                  if let err = error as? ServiceError {
                      // Then
                      XCTAssertEqual(err, .api(NSError(domain: "Domain", code: 999, userInfo: nil)))
                      expect.fulfill()
                  }
              default:
                  break
              }
              }
          })
          waitForExpectations(timeout: 1)
      }

    func test_ListViewControllerReturnItems() {

        // Given
        guard let events = try? JSONDecoder().decode([Occurrence].self, from: getEventListJsonMock()) else {
            return XCTFail()
        }

        eventAPIMock.eventsReturnValue = .success(events)
        listViewController.bind(feature:ListEventFeature(eventApi: eventAPIMock))

        // When
        let expect = expectation(description: "Wait for state to return")

        listViewController.feature.spin.render(on: self, using: { _ in return { state in
            switch state {
            case let .refreshed(page):
                // Then
                XCTAssertEqual(page.items.count, 3)
                expect.fulfill()

            default:
                break
            }
            }
        })
        waitForExpectations(timeout: 1)
    }

}
