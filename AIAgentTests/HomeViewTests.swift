//
//  AIAgentTests.swift
//  AIAgentTests
//
//  Created by Tony Short on 13/05/2023.
//

import ViewInspector
import XCTest

@testable import AIAgent

final class HomeViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWhenAppStartsThereIsAnAddPromptButton() throws {
        let sut = HomeView()
        XCTAssertEqual(try sut.inspect().find(button: "+ Add a Prompt").pathToRoot, "view(HomeView.self).navigationView().scrollView().lazyVGrid().view(PromptCellView.self, 1).button()")
    }

    func testShowsAddPromptWhenAddButtonPressed() throws {
        let sut = HomeView()
        let exp = sut.inspection.inspect { view in
            XCTAssertFalse(try view.actualView().isShowingAddPromptView)
            try view.navigationView().scrollView().lazyVGrid().view(PromptCellView.self, 1).button().tap()
            XCTAssertTrue(try view.actualView().isShowingAddPromptView)
        }
        ViewHosting.host(view: sut)
        self.wait(for: [exp], timeout: 1.0)
    }
}
