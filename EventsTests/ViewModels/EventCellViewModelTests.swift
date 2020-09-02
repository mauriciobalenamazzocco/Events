//
//  EventDetailViewModelTest.swift
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

class EventCellViewModelTests: XCTestCase {

    // MARK: - Subject under test
    var viewModel: EventCellViewModel!

    //Mocks

    func getEventJsonMock() -> Data {
        let testBundle = Bundle(for: type(of: self))
        guard let filePath = testBundle.path(forResource: "EventJsonMock", ofType: "txt")
            else { fatalError() }
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        return jsonData
    }

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
     }

    func test_ViewModelShouldBindItems() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)

        let dateObs = scheduler.createObserver(String?.self)
        let pictureObs = scheduler.createObserver(URL?.self)
        let priceObs = scheduler.createObserver(String?.self)
        let titleObs = scheduler.createObserver(String?.self)

        guard let event = try? JSONDecoder().decode(Occurrence.self, from: getEventJsonMock()) else {
               return XCTFail()
           }

        // When
        viewModel = EventCellViewModel(event: event)
        let output = viewModel.transform(input: .init())

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
        XCTAssertEqual(dateObs.events[0].value.element, "8/20/18, 2:00 PM")
        XCTAssertEqual(pictureObs.events[0].value.element, URL(string: "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png"))
        XCTAssertEqual(priceObs.events[0].value.element,"R$ 29.99")
        XCTAssertEqual(titleObs.events[0].value.element, "Feira de adoÃ§Ã£o de animais na RedenÃ§Ã£o")
    }
}
