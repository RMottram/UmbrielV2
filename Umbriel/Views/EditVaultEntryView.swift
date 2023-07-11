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
    @State var isLoginCopied:Bool = false
    @State var copiedString:String = ""
    @State var isHidden:Bool = true
    
    @State private var weakRed:Double = 255
    @State private var weakGreen:Double = 101
    @State private var weakBlue:Double = 101
    @State private var strongRed:Double = 117
    @State private var strongGreen:Double = 211
    @State private var strongBlue:Double = 99
    
    var body: some View {
        
        Form {
            Section(header: Text("Edit desired details for \(password.title!)").font(.system(size: 12, design: .rounded))) {
                TextField("\(password.loginItem!)", text: $loginItem).font(.system(.body, design: .rounded))
                    .onAppear {
                        loginItem = password.loginItem!
                        passwordEntry = password.password!
                        note = password.notes!
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                ZStack {
                    HStack {
                        TextField("\(password.password!)", text: $passwordEntry).font(.system(.body, design: .rounded))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .blur(radius: isHidden ? 7 : 0)
                            .onTapGesture { isHidden = false }
                        Button(action: {
                            self.hapticGen.simpleSelectionFeedback()
                            isHidden.toggle()
                        })
                        {
                            Image(systemName: isHidden ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor((self.isHidden == false ) ? Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255) : (Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255)))
                        }
                    }
                }
                TextField("\(password.notes!)", text: $note).font(.system(.body, design: .rounded))
                    .disableAutocorrection(false)
            }
            
            Section(header: Text("\(copiedString)").font(.system(size: 12, design: .rounded))) {
                Button(action: {
                    self.hapticGen.simpleSuccess()
                    DataController().editVaultEntry(vault: password, loginItem: loginItem, notes: note, password: passwordEntry, context: managedObjectContext)
                    self.presentationMode.wrappedValue.dismiss()
                })
                {
                    Text("Save").font(.system(.body, design: .rounded))
                }
                Button(action: {
                    self.hapticGen.simpleSelectionFeedback()
                    isLoginCopied = true
                    UIPasteboard.general.string = self.password.loginItem
                    
                    DispatchQueue.main.asyncAfter(deadline: .now())
                    {
                        withAnimation { copiedString = "Login Copied!" }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3)
                    {
                        withAnimation { copiedString = "" }
                    }
                    
                })
                {
                    Text("Copy Login").font(.system(.body, design: .rounded))
                }
                Button(action: {
                    self.hapticGen.simpleSelectionFeedback()
                    UIPasteboard.general.string = self.password.password
                    
                    DispatchQueue.main.asyncAfter(deadline: .now())
                    {
                        withAnimation { copiedString = "Password Copied!" }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                    {
                        withAnimation { copiedString = "" }
                    }
                })
                {
                    Text("Copy Password").font(.system(.body, design: .rounded))
                }
            }
            
        }
    }
}

//struct EditVaultEntryView_Preview: PreviewProvider {
//    static var previews: some View {
//        EditVaultEntryView(password: password)
//    }
//}
