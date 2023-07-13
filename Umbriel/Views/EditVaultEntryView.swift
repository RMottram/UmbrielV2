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
    var passwordTester = PasswordLogic()
    
    @State var loginItem:String = ""
    @State var passwordEntry:String = ""
    @State var note:String = ""
    @State var strength:String = ""
    @State var strengthVerdict:String = ""
    @State var isLoginCopied:Bool = false
    @State var copiedString:String = ""
    @State var isHidden:Bool = true
    @State var isBlank:Bool = false
    @State var isWeak:Bool = false
    @State var isAverage:Bool = false
    @State var isStrong:Bool = true
    @State var isVStrong:Bool = false
    
    var body: some View {
        
        Form {
            Section {
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
                                .foregroundColor((self.isHidden == false ) ? .strongColour : (.weakColour))
                        }
                    }
                }
                TextField("\(password.notes!)", text: $note).font(.system(.body, design: .rounded))
                    .disableAutocorrection(false)
            } header: {
                Text("Edit desired details for \(password.title!)")
                    .font(.system(size: 12, design: .rounded))
            } footer: {
                Group {
                    Text("Password is ")
                        .font(.system(.body, design: .rounded)) +
                    Text("\(password.passwordStrength!)")
                        .fontWeight(Font.Weight.bold)
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(getColor(for: password.passwordStrength!))
                }
            }
            
            Section(header: Text("\(copiedString)").font(.system(size: 12, design: .rounded))) {
                Button(action: {
                    TestPass()
                    self.hapticGen.simpleSuccess()
                    DataController().editVaultEntry(vault: password,
                                                    loginItem: loginItem,
                                                    notes: note,
                                                    password: passwordEntry,
                                                    strength: strengthVerdict,
                                                    context: managedObjectContext)
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
    
    private func TestPass() {
        
        switch self.passwordTester.TestStrength(password: passwordEntry)
        {
            case .Blank:
                self.isBlank = true
            case .Weak:
                self.isWeak = true
            strengthVerdict = "Weak"
            case .Average:
                self.isAverage = true
            strengthVerdict = "Average"
            case .Strong:
                self.isStrong = true
            strengthVerdict = "Strong"
            case .VeryStrong:
                self.isVStrong = true
            strengthVerdict = "Very Strong"
        }
    }
    
    func getColor(for verdict: String) -> Color {
        switch verdict {
        case "Weak":
            return .weakColour
        case "Average":
            return .averageColour
        case "Strong":
            return .strongColour
        case "Very Strong":
            return .vStrongColour
        default:
            return .pink
        }
    }
    
}

//struct EditVaultEntryView_Preview: PreviewProvider {
//    static var previews: some View {
//        EditVaultEntryView(password: password)
//    }
//}
