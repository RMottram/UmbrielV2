//
//  UmbrielApp.swift
//  Umbriel
//
//  Created by Ryan Mottram on 30/06/2023.
//

import SwiftUI

@main
struct UmbrielApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
