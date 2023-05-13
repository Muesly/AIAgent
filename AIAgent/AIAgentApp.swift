//
//  AIAgentApp.swift
//  AIAgent
//
//  Created by Tony Short on 13/05/2023.
//

import SwiftUI

@main
struct AIAgentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
