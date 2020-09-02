//
//  CheckinViewControllerTests.swift
//  EventsTests
//
//  Created by Mauricio Balena Mazzocco on 02/09/20.
//  Copyright © 2020 Mauricio Mazzocco. All rights reserved.
//

import Foundation
import XCTest
@testable import Events

class CheckinViewControllerTests: XCTestCase
{
    // MARK: - Subject under test

    var viewController: CheckinViewController!

    var window: UIWindow!

    // MARK: - Test lifecycle
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
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
        viewController = CheckinViewController()
    }

    func loadView()
    {
        window.addSubview(viewController.view)
        RunLoop.current.run(until: Date())
    }

    func test_viewControllerViewShouldCorrectDisplayEvent() {
        // Given
        let viewModel = CheckinViewModel(eventTitle: "title", eventPrice: 29.99, eventDate: "10/10/2020 14:00", eventId: "1", eventPicture: URL(string: ""), coordinator:  EventCoordinator().weakRouter)
        viewController.bind(to: viewModel)

        // Then
        XCTAssertEqual(viewController.checkinView.titleLabel.text, "title")
        XCTAssertEqual(viewController.checkinView.dateLabel.text, "10/10/2020 14:00")

        XCTAssertEqual(viewController.checkinView.priceLabel.text, "R$ 29.99")

    }
}
