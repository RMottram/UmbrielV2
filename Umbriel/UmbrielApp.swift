//
//  UmbrielApp.swift
//  Umbriel
//
//  Created by Ryan Mottram on 30/06/2023.
//

import SwiftUI
import SwiftData

@main
struct UmbrielApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: VaultEntry.self)
        .onChange(of: UIApplication.shared.applicationState) { _, state in
            if state == .inactive {
                // Handle app becoming inactive (e.g., freezing or crashing)
                fatalError("App has become inactive.")
            }
        }
    }
}
