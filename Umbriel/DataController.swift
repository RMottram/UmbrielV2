//
//  DataController.swift
//  Umbriel
//
//  Created by Ryan Mottram on 01/07/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "Vault")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("failed to load data model \(error.localizedDescription)")
            }
            
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("data saved!")
        } catch {
            print("data not saved!")
        }
    }
    
    func addVaultEntry(password: String, title: String, loginItem: String, notes: String, strength: String, context: NSManagedObjectContext) {
        let vaultEntry = Vault(context: context)
        vaultEntry.id = UUID()
        vaultEntry.dateCreated = Date()
        vaultEntry.loginItem = loginItem
        vaultEntry.notes = notes
        vaultEntry.password = password
        vaultEntry.title = title
        vaultEntry.passwordStrength = strength
        
        save(context: context)
    }
    
    func editVaultEntry(vault: Vault, loginItem: String, notes: String, password: String, strength: String, context: NSManagedObjectContext) {
        vault.loginItem = loginItem
        vault.notes = notes
        vault.password = password
        vault.passwordStrength = strength
        
        save(context: context)
    }
    
}
