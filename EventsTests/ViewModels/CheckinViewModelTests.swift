//
//  CheckinViewModelTests.swift
//  EventsTests
//
//  Created by Mauricio Balena Mazzocco on 01/09/20.
//  Copyright © 2020 Mauricio Mazzocco. All rights reserved.
//

import Foundation
@testable import Events
import XCTest
import RxSwift
import RxTest

class CheckinViewModelTests: XCTestCase {

    // MARK: - Subject under test
    var viewModel: CheckinViewModel!

    //MARK: - Mocks
    var checkinAPIMock: CheckinAPIMock!

    var disposeBag: DisposeBag!

    override func setUp()
     {
         super.setUp()
         setupAPI()
     }

     override func tearDown()
     {
         super.tearDown()
     }

     // MARK: - Test setup

     func setupAPI()
     {
         disposeBag = DisposeBag()
         checkinAPIMock = CheckinAPIMock()
     }

    func test_ViewModelShouldBindItems() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)

        let dateObs = scheduler.createObserver(String.self)
        let pictureObs = scheduler.createObserver(URL?.self)
        let priceObs = scheduler.createObserver(String?.self)
        let titleObs = scheduler.createObserver(String.self)

        // When
        viewModel = CheckinViewModel(eventTitle: "Evento1",
                                     eventPrice: 55,
                                     eventDate:"Data", eventId: "id",
                                     eventPicture: URL(string: ""),
                                     coordinator: EventCoordinator().weakRouter)
        let output = viewModel.transform(input: .init(checking: .empty(), close: .empty()))

        output
            .date
            .drive(dateObs)
            .disposed(by: disposeBag)

        output
            .picture
            .drive(pictureObs)
            .disposed(by: disposeBag)

        output
            .price
            .drive(priceObs)
            .disposed(by: disposeBag)

        output
            .title
            .drive(titleObs)
            .disposed(by: disposeBag)

        scheduler.start()

        // Then
        XCTAssertEqual(dateObs.events[0].value.element, "Data")
        XCTAssertEqual(pictureObs.events[0].value.element, URL(string: ""))
        XCTAssertEqual(priceObs.events[0].value.element,"R$ \(55.0)")
        XCTAssertEqual(titleObs.events[0].value.element, "Evento1")
    }


    func test_ViewModelShuldEmitSecurityError() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)

        let obsTrigger = scheduler.createColdObservable([.next(0, ())])

        // When
        viewModel = CheckinViewModel(eventTitle: "Evento1",
                                     eventPrice: 55,
                                     eventDate:"Data", eventId: "id",
                                     eventPicture: URL(string: ""),
                                     coordinator: EventCoordinator().weakRouter) //Mock coordinator latter


        _ = viewModel.transform(input: .init(checking: obsTrigger.map { _ -> (String?, String?) in
            return ("", "mauricio@gmail.com")
        }.asDriver(onErrorDriveWith: .just(("", ""))), close: .empty()))

        let expect = expectation(description: "Wait for securityFail to return")

        viewModel.spin.render(on: self, using: { _ in return { state in
            switch state {
            case .securityFail(name: let name, email: let email):
                // Then
                XCTAssertFalse(name, "Cannot post because fail in name security")
                XCTAssertTrue(email, "Email security should pass")
                expect.fulfill()
            default:
                break
            }
            }
        })
        viewModel.spin.start()

        scheduler.start()

        waitForExpectations(timeout: 1)

    }


    func test_ViewModelShouldRegister() {
           // Given
           let scheduler = TestScheduler(initialClock: 0)

           let obsTrigger = scheduler.createColdObservable([.next(0, ())])

            checkinAPIMock.checkinReturnValue = .success(Void())

           // When
           viewModel = CheckinViewModel(eventTitle: "Evento1",
                                        eventPrice: 55,
                                        eventDate:"Data", eventId: "id",
                                        eventPicture: URL(string: ""),
                                        checkinAPI: checkinAPIMock,
                                        coordinator: EventCoordinator().weakRouter) //Mock coordinator latter


           _ = viewModel.transform(input: .init(checking: obsTrigger.map { _ -> (String?, String?) in
               return ("Mauricio", "mauricio@gmail.com")
           }.asDriver(onErrorDriveWith: .just(("", ""))), close: .empty()))

           let expect = expectation(description: "Wait for securityFail to return")

           viewModel.spin.render(on: self, using: { _ in return { state in
               switch state {
               case .registred:
                   // Then
                   expect.fulfill()
               default:
                   break
               }
               }
           })
           viewModel.spin.start()

           scheduler.start()

           waitForExpectations(timeout: 1)

       }

    func test_ViewModelShouldError() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)

        let obsTrigger = scheduler.createColdObservable([.next(0, ())])

        checkinAPIMock.checkinReturnValue = .failure(.unauthorized)

        // When
        viewModel = CheckinViewModel(eventTitle: "Evento1",
                                     eventPrice: 55,
                                     eventDate:"Data", eventId: "id",
                                     eventPicture: URL(string: ""),
                                     checkinAPI: checkinAPIMock,
                                     coordinator: EventCoordinator().weakRouter) //Mock coordinator latter


        _ = viewModel.transform(input: .init(checking: obsTrigger.map { _ -> (String?, String?) in
            return ("Mauricio", "mauricio@gmail.com")
        }.asDriver(onErrorDriveWith: .just(("", ""))), close: .empty()))

        let expect = expectation(description: "Wait for securityFail to return")

        viewModel.spin.render(on: self, using: { _ in return { state in
            switch state {
            case .error(let error):
                // Then
                switch error {
                case .unauthorized:
                    expect.fulfill()
                default:
                    break
                }
            default:
                break
            }
            }
        })
        viewModel.spin.start()

        scheduler.start()

        waitForExpectations(timeout: 1)

    }
}

