//
//  OcurrenceTest.swift
//  EventsTests
//
//  Created by Mauricio Balena Mazzocco on 01/09/20.
//  Copyright © 2020 Mauricio Mazzocco. All rights reserved.
//
import Foundation
@testable import Events
import XCTest

class OcurrenceTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func getJsonMock() -> Data {
        let testBundle = Bundle(for: type(of: self))
        guard let filePath = testBundle.path(forResource: "EventJsonMock", ofType: "txt")
        else { fatalError() }
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        return jsonData
    }

    func testFieldsCorrect() {
        guard let event = try? JSONDecoder().decode(Occurrence.self, from: getJsonMock()) else {
            return XCTFail()
        }

        XCTAssertEqual(event.date, 1534784400000)
        XCTAssertEqual(event.description, "O Patas Dadas estarÃ¡ na RedenÃ§Ã£o, nesse domingo, com cÃ£es para adoÃ§Ã£o e produtos Ã  venda!\n\nNa ocasiÃ£o, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarÃ£o prontinhos para ganhar o â™¥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doaÃ§Ã£o:\n- guias e coleiras em bom estado\n- raÃ§Ã£o (as que mais precisamos no momento sÃ£o sÃªnior e filhote)\n- roupinhas \n- cobertas \n- remÃ©dios dentro do prazo de validade")
        XCTAssertEqual(event.id, "1")
        XCTAssertEqual(event.title, "Feira de adoÃ§Ã£o de animais na RedenÃ§Ã£o")
        XCTAssertEqual(event.price, 29.99)


    }

    func testEquals_Event() {
        let event1 = Occurrence(id: "id", date: 123, title: "titutlo", price: 0, image: "image", description: "description")
        let event2 = Occurrence(id: "id", date: 123, title: "titutlo", price: 0, image: "image", description: "description")

        XCTAssertEqual(event1, event2)
    }
}

