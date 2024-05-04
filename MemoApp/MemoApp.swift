//
//  MemoAppApp.swift
//  MemoApp
//
//  Created by Vincent on 2024/05/04.
//

import SwiftUI

@main
struct MemoApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
