//
//  EventCellTests.swift
//  EventsTests
//
//  Created by Mauricio Balena Mazzocco on 02/09/20.
//  Copyright © 2020 Mauricio Mazzocco. All rights reserved.
//
import Foundation
@testable import Events
import XCTest

class EventCellTests: XCTestCase {

    // MARK: - Subject under test
    var cell: EventCell!

    //Mocks

    func getEventJsonMock() -> Data {
        let testBundle = Bundle(for: type(of: self))
        guard let filePath = testBundle.path(forResource: "EventJsonMock", ofType: "txt")
            else { fatalError() }
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        return jsonData
    }

     // MARK: - Test setup


    override func setUp()
    {
        super.setUp()
        cell = EventCell.initFromNib()
    }


    func test_ViewModelShouldBindItems() {

        // Given
        guard let event = try? JSONDecoder().decode(Occurrence.self, from: getEventJsonMock()) else {
               return XCTFail()
           }

        // When
        let viewModel = EventCellViewModel(event: event)
        cell.bind(to: viewModel)

        //Then
        XCTAssertEqual(cell.titleLabel.text, "Feira de adoÃ§Ã£o de animais na RedenÃ§Ã£o")
        XCTAssertTrue(cell.dateLabel.text != "")
        XCTAssertEqual(cell.priceLabel.text, "R$ 29.99")
        XCTAssertEqual(cell.descriptionLabel.text, "O Patas Dadas estarÃ¡ na RedenÃ§Ã£o, nesse domingo, com cÃ£es para adoÃ§Ã£o e produtos Ã  venda!\n\nNa ocasiÃ£o, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarÃ£o prontinhos para ganhar o â™¥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doaÃ§Ã£o:\n- guias e coleiras em bom estado\n- raÃ§Ã£o (as que mais precisamos no momento sÃ£o sÃªnior e filhote)\n- roupinhas \n- cobertas \n- remÃ©dios dentro do prazo de validade")
    }
}
