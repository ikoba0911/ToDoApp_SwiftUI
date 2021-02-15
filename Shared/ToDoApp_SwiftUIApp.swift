//
//  ToDoApp_SwiftUIApp.swift
//  Shared
//
//  Created by IkkiKobayashi on 2021/02/15.
//

import SwiftUI

@main
struct ToDoApp_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
