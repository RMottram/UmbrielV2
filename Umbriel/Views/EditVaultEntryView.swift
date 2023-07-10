//
//  EditVaultEntryView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 07/07/2023.
//

import SwiftUI

struct EditVaultEntryView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    var password: FetchedResults<Vault>.Element
    var hapticGen = Haptics()
    
    @State var loginItem:String = ""
    @State var passwordEntry:String = ""
    @State var note:String = ""
    
    var body: some View {
        
        Form {
            Section(header: Text("Blank fields will preserve current information for \(password.title!)").font(.system(size: 12, design: .rounded))) {
                TextField("\(password.loginItem!)", text: $loginItem).font(.system(.body, design: .rounded))
                    .onAppear {
                        loginItem = password.loginItem!
                        passwordEntry = password.password!
                        note = password.notes!
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                TextField("\(password.password!)", text: $passwordEntry).font(.system(.body, design: .rounded))
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                TextField("\(password.notes!)", text: $note).font(.system(.body, design: .rounded))
                    .disableAutocorrection(false)
            }
            
            Button(action: {
                self.hapticGen.simpleSuccess()
                DataController().editVaultEntry(vault: password, loginItem: loginItem, notes: note, password: passwordEntry, context: managedObjectContext)
                self.presentationMode.wrappedValue.dismiss()
            })
            {
                Text("Save").font(.system(.body, design: .rounded))
            }
            
        }
        
    }
}

//struct EditVaultEntryView: PreviewProvider {
//    static var previews: some View {
//        EditVaultEntryView()
//    }
//}
