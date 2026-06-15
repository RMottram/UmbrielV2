//
//  DataController.swift
//  Umbriel
//
//  Created by Ryan Mottram on 01/07/2023.
//

import Foundation
import SwiftData

enum DataController {

    static func deleteAllEntries(context: ModelContext) {
        do {
            try context.delete(model: VaultEntry.self)
            try context.save()
        } catch {
            print("Failed to delete all entries: \(error.localizedDescription)")
        }
    }
}
