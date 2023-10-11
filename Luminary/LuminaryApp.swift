//
//  LuminaryApp.swift
//  Luminary
//
//  Created by Andrea Oquendo on 25/09/23.
//

import SwiftUI

@main
struct LuminaryApp: App {

    let coreDataController = CoreData.shared

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataController.persistentContainer.viewContext)
                .onAppear {
                    /* TO-DO */
                    let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
                    
                    if isFirstLaunch {
                        print("nao eh")
                    } else {
                        
                        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                    }
                }
        }
    }
}
