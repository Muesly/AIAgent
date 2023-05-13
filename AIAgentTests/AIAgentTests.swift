//
//  AIAgentTests.swift
//  AIAgentTests
//
//  Created by Tony Short on 13/05/2023.
//

import ViewInspector
import XCTest

@testable import AIAgent

final class AIAgentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWhenAppStartsThereIsAnAddPromptButton() throws {
        let sut = HomeView()
        XCTAssertEqual(try sut.inspect().find(text: "+ Add a Prompt").pathToRoot, "view(HomeView.self).navigationView().scrollView().lazyVGrid().view(PromptCellView.self, 1).button().labelView().text()")
    }
}
