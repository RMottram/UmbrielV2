//
//  VaultEntry.swift
//  Umbriel
//
//  Created by Ryan Mottram on 14/06/2026.
//

import Foundation
import SwiftData

@Model
final class VaultEntry {
    var id: UUID
    var dateCreated: Date
    var title: String
    var loginItem: String
    var password: String
    var notes: String
    var passwordStrength: String
    var strengthScore: Double

    init(
        id: UUID = UUID(),
        dateCreated: Date = Date(),
        title: String,
        loginItem: String,
        password: String,
        notes: String,
        passwordStrength: String,
        strengthScore: Double
    ) {
        self.id = id
        self.dateCreated = dateCreated
        self.title = title
        self.loginItem = loginItem
        self.password = password
        self.notes = notes
        self.passwordStrength = passwordStrength
        self.strengthScore = strengthScore
    }
}
