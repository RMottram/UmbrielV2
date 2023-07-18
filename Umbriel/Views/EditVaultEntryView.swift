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
    @State var strengthScore:Double = 0.0
    @State var isLoginCopied:Bool = false
    @State var copiedString:String = ""
    @State var isAnyInfoMissing:Bool = false
    @State var isHidden:Bool = true
    @State var isBlank:Bool = false
    @State var isWeak:Bool = false
    @State var isAverage:Bool = false
    @State var isStrong:Bool = true
    @State var isVStrong:Bool = false
    
    var body: some View {
        
        Form {
            Section(header: Text("Login")
                .font(.system(size: 12, design: .rounded))) {
                    TextField("\(password.loginItem!)", text: $loginItem).font(.system(.body, design: .rounded))
                        .onAppear {
                            loginItem = password.loginItem!
                            passwordEntry = password.password!
                            note = password.notes!
                            strengthScore = password.strengthScore
                            print("password.strengthScore - \(password.strengthScore)")
                            print("strengthScore - \(strengthScore)")
                        }
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
            
            Section {
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
            } header: {
                Text("Password")
                    .font(.system(size: 12, design: .rounded))
            } footer: {
                Group {
                    Text("Password is ")
                        .font(.system(size: 14, design: .rounded)) +
                    Text("\(password.passwordStrength!)")
                        .fontWeight(Font.Weight.bold)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(getColor(for: password.passwordStrength!))
                }
            }
            if #available(iOS 16.0, *) {
                Section {
                    HStack {
                        Spacer()
                        Gauge(value: password.strengthScore, in: 0...10) {
                        } currentValueLabel: {
                            Text(String(format: "%.0f", password.strengthScore))
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("10")
                        }
                        .scaleEffect(1.2)
                        .gaugeStyle(.accessoryCircular)
                        .tint(Gradient(colors: [.weakColour, .averageColour, .strongColour, .vStrongColour]))
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("Notes")
                .font(.system(size: 12, design: .rounded))) {
                    TextField("\(password.notes!)", text: $note).font(.system(.body, design: .rounded))
                        .disableAutocorrection(false)
                }
            
            
            Section(header: Text("\(copiedString)").font(.system(size: 12, design: .rounded))) {
                Button("Save") {
                    if loginItem.isEmpty || passwordEntry.isEmpty {
                        isAnyInfoMissing = true
                        hapticGen.simpleError()
                    } else {
                        TestPass()
                        let score = passwordTester.TestStrength(password: passwordEntry)
                        self.hapticGen.simpleSuccess()
                        DataController().editVaultEntry(vault: password,
                                                        loginItem: loginItem,
                                                        notes: note,
                                                        password: passwordEntry,
                                                        strength: strengthVerdict,
                                                        strengthScore: score.rawValue,
                                                        context: managedObjectContext)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }.font(.system(.body, design: .rounded))
                
                Button("Copy Login") {
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
                    
                }.font(.system(.body, design: .rounded))
                
                Button("Copy Password") {
                    self.hapticGen.simpleSelectionFeedback()
                    UIPasteboard.general.string = self.password.password
                    
                    DispatchQueue.main.asyncAfter(deadline: .now())
                    {
                        withAnimation { copiedString = "Password Copied!" }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3)
                    {
                        withAnimation { copiedString = "" }
                    }
                }.font(.system(.body, design: .rounded))
            }
            .alert(isPresented: $isAnyInfoMissing) {
                Alert(title: Text("Missing Information"), message: Text("One or more required fields were left blank, please ensure to enter all required information"),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    //        .overlay(
    //            VStack {
    //                Spacer()
    //                if #available(iOS 16.0, *) {
    //                    Spacer()
    //                    Gauge(value: password.strengthScore, in: 0...10) {
    //                    } currentValueLabel: {
    //                        Text(String(format: "%.0f", password.strengthScore))
    //                    } minimumValueLabel: {
    //                        Text("0")
    //                    } maximumValueLabel: {
    //                        Text("10")
    //                    }
    //                    .gaugeStyle(.accessoryCircular)
    //                    .tint(Gradient(colors: [.weakColour, .averageColour, .strongColour, .vStrongColour]))
    //                } else {
    //                    // Fallback on earlier versions
    //                }
    //                Spacer()
    //            }.offset(y:20)
    //        )
    //        .ignoresSafeArea(.keyboard)
    //    }
    
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
