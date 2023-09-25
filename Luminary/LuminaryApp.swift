//
//  LuminaryApp.swift
//  Luminary
//
//  Created by Andrea Oquendo on 25/09/23.
//

import SwiftUI

@main
struct LuminaryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
