//
//  AddNewPasswordView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 04/07/2023.
//

import SwiftUI

struct AddNewPasswordView: View {
    
    var hapticGen = Haptics()
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isAnyInfoMissing:Bool = false
    @State private var isSheetPresented:Bool = false
    @State var passwordTitle:String = ""
    @State var loginItem:String = ""
    @State var passwordEntry:String = ""
    @State var note:String = ""
    
    var body: some View {
        
        Form {
            Section {
                VStack {
                    // MARK: Password Entry Details
                    TextField("*Password Description", text: $passwordTitle)
                        .font(.system(.body, design: .rounded))
                        .autocapitalization(.words)
                        .disableAutocorrection(false)
                    
                    
                    TextField("*Login Item", text: $loginItem)
                        .font(.system(.body, design: .rounded))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    TextField("*Password", text: $passwordEntry)
                    .font(.system(.body, design: .rounded))
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    
                }
            }
            HStack {
                Spacer()
                Button("Submit") {
                    if self.passwordTitle == "" || self.passwordEntry == "" || self.loginItem == "" {
                        self.isAnyInfoMissing = true
                        self.hapticGen.simpleError()
                    } else {
                        self.hapticGen.simpleSuccess()
                        DataController().addVaultEntry(password: passwordEntry,
                                                       title: passwordTitle,
                                                       loginItem: loginItem,
                                                       notes: "\(passwordTitle) note",
                                                       context: context)
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .alert(isPresented: self.$isAnyInfoMissing) {
                    Alert(title: Text("Missing Information"), message: Text("One or more required fields were left blank, please ensure to enter all required information"),
                          dismissButton: .default(Text("OK")))
                }
                Spacer()
            }
        }
        
    }
    
    private func dismiss() {
            isSheetPresented = false
            presentationMode.wrappedValue.dismiss()
        }
    
}

struct AddNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPasswordView()
    }
}
