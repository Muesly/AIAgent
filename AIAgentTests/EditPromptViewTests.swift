//
//  EditPromptViewTests.swift
//  AIAgentTests
//
//  Created by Tony Short on 13/05/2023.
//

import CoreData
import SwiftUI
import ViewInspector
import XCTest

@testable import AIAgent

final class EditPromptViewTests: XCTestCase {
    var viewContext: NSManagedObjectContext!

    override func setUp() {
        viewContext = PersistenceController(inMemory: true).container.viewContext
    }

    func testEditPromptView() throws {
        let prompt = Prompt(context: viewContext)
        prompt.title = "asdf"
        let sut = EditPromptView(prompt: prompt)
        let textField = try sut.inspect().find(ViewType.TextField.self)

        XCTAssertEqual(textField.pathToRoot, "view(EditPromptView.self).navigationView().vStack().form(0).section(0).textField(0)")
        XCTAssertEqual(try textField.input(), "asdf")
    }
}

