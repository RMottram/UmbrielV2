//
//  PasswordGeneratorView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 30/06/2023.
//

import Foundation
import SwiftUI

struct PasswordGeneratorView: View {
    
    var hapticGen = Haptics()
    
    @State var showCopyNote:Bool = false
    @State var generatedPassword = "Password generates here!"
    @State var passwordLength:Double = 8
    @State var numbersLength:Double = 2
    @State var symbolsLength:Double = 2
    @State var selectedPattern:NumsOrMixed = .mixed
    
    @State var isNumbers = false
    @State var isSymbols = false
    @State var isUppercase = false
    
    var fraction: CGFloat = 1.0
    
    var body: some View {
        
        VStack {
            
//            NotificationBannerView()
//                .offset(x: self.showCopyNote ? UIScreen.main.bounds.width/3 : UIScreen.main.bounds.width)
//                .animation(.interpolatingSpring(mass: 1, stiffness: 80, damping: 10, initialVelocity: 1))
//                .onTapGesture {
//                    withAnimation {
//                        self.showCopyNote = false
//                    }
//            }
//            .onDisappear(perform: {
//                self.showCopyNote = false
//            })
            
            // MARK: Password Generator Field
            TextEditor(text: $generatedPassword)
                .padding(.horizontal)
                .font(Font.custom("Menlo", size: 24))
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .frame(height: 100)
                .offset(y: 10)
                .disabled(true)
            
            Picker("", selection: $selectedPattern) {
                ForEach(NumsOrMixed.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            //Form {
                
//                // MARK: Password Length Slider
//                Section(header: Text("Length: \(NoDecimal(number: passwordLength))").font(.system(size: 12, design: .rounded))) {
//
                //Section {
            ExtractedView(
                chosenPattern: selectedPattern,
                passwordLength: $passwordLength,
                generatedPassword: $generatedPassword,
                isNumbers: $isNumbers,
                isSymbols: $isSymbols,
                hapticGen: hapticGen,
                showCopyNote: $showCopyNote
            )
//                }
//
//                }
//                // MARK: Password Options
//                Section(header: Text("Configurations").font(.system(size: 12, design: .rounded))) {
//
//                    Toggle(isOn: self.$isNumbers) {
//                        Text("Numbers").font(.system(.body, design: .rounded))
//                    }
//                    .onTapGesture {
//                        //self.buttonPressed = true
//                        self.generatedPassword = randomPasswordWithUppercaseLowercase(length: Int(self.passwordLength))
//
//                        if self.isNumbers {
//                            self.generatedPassword = randomPasswordWithNumbers(length: Int(self.passwordLength))
//                        }
//                        if self.isSymbols {
//                            self.generatedPassword = randomPasswordWithSymbols(length: Int(self.passwordLength))
//                        }
//                        if self.isSymbols && self.isNumbers {
//                            self.generatedPassword = randomPasswordWithAll(length: Int(self.passwordLength))
//                        }
//                        self.hapticGen.simpleSelectionFeedback()
//                    }
//                    Toggle(isOn: self.$isSymbols) {
//                        Text("Symbols").font(.system(.body, design: .rounded))
//                    }.onTapGesture {
//                        //self.buttonPressed = true
//                        self.generatedPassword = randomPasswordWithUppercaseLowercase(length: Int(self.passwordLength))
//
//                        if self.isNumbers {
//                            self.generatedPassword = randomPasswordWithNumbers(length: Int(self.passwordLength))
//                        }
//                        if self.isSymbols {
//                            self.generatedPassword = randomPasswordWithSymbols(length: Int(self.passwordLength))
//                        }
//                        if self.isSymbols && self.isNumbers {
//                            self.generatedPassword = randomPasswordWithAll(length: Int(self.passwordLength))
//                        }
//                        self.hapticGen.simpleSelectionFeedback()
//                    }
//
//                }
//                // MARK: Generate and Copy Buttons
//                    Button(action: {
//
//                            //self.buttonPressed = true
//                            self.hapticGen.simpleSuccess()
//
//                            self.generatedPassword = randomPasswordWithUppercaseLowercase(length: Int(self.passwordLength))
//
//                            if self.isNumbers {
//                                self.generatedPassword = randomPasswordWithNumbers(length: Int(self.passwordLength))
//                            }
//                            if self.isSymbols {
//                                self.generatedPassword = randomPasswordWithSymbols(length: Int(self.passwordLength))
//                            }
//                            if self.isSymbols && self.isNumbers {
//                                self.generatedPassword = randomPasswordWithAll(length: Int(self.passwordLength))
//                            }
//
//                    }) {
//                            Text("Generate").font(.system(.body, design: .rounded))
//                    }
//                    Button(action: {
//                        self.hapticGen.simpleSuccess()
//                        UIPasteboard.general.string = self.generatedPassword
//                        self.showCopyNote = true
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 4)
//                        {
//                            withAnimation { self.showCopyNote = false }
//                        }
//
//                    })
//                    {
//                        Text("Copy password").font(.system(.body, design: .rounded))
//                    }
            //}.offset(y: 30)
        }.onChange(of: selectedPattern) {_ in
            generatedPassword = "Password generates here!"
        }
    }
}

struct ExtractedView: View {
    
    var chosenPattern: NumsOrMixed
    @Binding var passwordLength: Double
    @Binding var generatedPassword: String
    @Binding var isNumbers: Bool
    @Binding var isSymbols: Bool
    
    var hapticGen: Haptics
    @Binding var showCopyNote: Bool
    @State var copiedString: String = ""
    
    var body: some View {
        
        switch chosenPattern {
            
        case .nums:
            Form {
                Section(header: Text("Length: \(NoDecimal(number: passwordLength))").font(.system(size: 12, design: .rounded))) {
                    HStack {
                        Text("8").font(.system(.body, design: .rounded))
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [.weakColour, .averageColour, .strongColour, .vStrongColour]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(Slider(value: $passwordLength, in: 8...40, step: 1))
                            Slider(value: $passwordLength, in: 8...40, step: 1, onEditingChanged: {_ in
                                self.generatedPassword = randomPasswordJustNumbers(length: Int(self.passwordLength))
                            })
                            .opacity(0.02)
                            
                        }
                        Text("40").font(.system(.body, design: .rounded))
                    }
                }
                
                Section(header: Text("\(copiedString)").font(.system(size: 12, design: .rounded))) {
                    Button(action: {
                        self.hapticGen.simpleSuccess()
                        
                        self.generatedPassword = randomPasswordJustNumbers(length: Int(self.passwordLength))
                        
                    }) {
                        Text("Generate").font(.system(.body, design: .rounded))
                    }
                    Button(action: {
                        self.hapticGen.simpleSuccess()
                        UIPasteboard.general.string = self.generatedPassword
                        self.showCopyNote = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now())
                        {
                            withAnimation { copiedString = "Password Copied!" }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
                        {
                            withAnimation { copiedString = "" }
                        }
                        
                    })
                    {
                        Text("Copy Password").font(.system(.body, design: .rounded))
                    }
                }
                
            }
            
        case .mixed:
            Form {
                Section(header: Text("Length: \(NoDecimal(number: passwordLength))").font(.system(size: 12, design: .rounded))) {
                    HStack {
                        Text("8").font(.system(.body, design: .rounded))
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [.weakColour, .averageColour, .strongColour, .vStrongColour]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(Slider(value: $passwordLength, in: 8...40, step: 1))
                            Slider(value: $passwordLength, in: 8...40, step: 1, onEditingChanged: {_ in
                                self.generatedPassword = randomPasswordWithUppercaseLowercase(length: Int(self.passwordLength))
                                
                                if self.isNumbers {
                                    self.generatedPassword = randomPasswordWithNumbers(length: Int(self.passwordLength))
                                }
                                if self.isSymbols {
                                    self.generatedPassword = randomPasswordWithSymbols(length: Int(self.passwordLength))
                                }
                                if self.isSymbols && self.isNumbers {
                                    self.generatedPassword = randomPasswordWithAll(length: Int(self.passwordLength))
                                }
                            })
                            .opacity(0.02)
                            
                        }
                        Text("40").font(.system(.body, design: .rounded))
                    }
                }
                
                Toggle(isOn: self.$isNumbers) {
                    Text("Numbers").font(.system(.body, design: .rounded))
                }
                .onTapGesture {
                    isNumbers.toggle()
                    self.generatedPassword = randomPasswordWithUppercaseLowercase(length: Int(self.passwordLength))
                    
                    if self.isNumbers {
                        self.generatedPassword = randomPasswordWithNumbers(length: Int(self.passwordLength))
                    }
                    if self.isSymbols {
                        self.generatedPassword = randomPasswordWithSymbols(length: Int(self.passwordLength))
                    }
                    if self.isSymbols && self.isNumbers {
                        self.generatedPassword = randomPasswordWithAll(length: Int(self.passwordLength))
                    }
                    self.hapticGen.simpleSelectionFeedback()
                }
                Toggle(isOn: self.$isSymbols) {
                    Text("Symbols").font(.system(.body, design: .rounded))
                }.onTapGesture {
                    isSymbols.toggle()
                    self.generatedPassword = randomPasswordWithUppercaseLowercase(length: Int(self.passwordLength))
                    
                    if self.isNumbers {
                        self.generatedPassword = randomPasswordWithNumbers(length: Int(self.passwordLength))
                    }
                    if self.isSymbols {
                        self.generatedPassword = randomPasswordWithSymbols(length: Int(self.passwordLength))
                    }
                    if self.isSymbols && self.isNumbers {
                        self.generatedPassword = randomPasswordWithAll(length: Int(self.passwordLength))
                    }
                    self.hapticGen.simpleSelectionFeedback()
                }
                
                Section(header: Text("\(copiedString)").font(.system(size: 12, design: .rounded))) {
                    Button(action: {
                        self.hapticGen.simpleSuccess()
                        
                        self.generatedPassword = randomPasswordWithUppercaseLowercase(length: Int(self.passwordLength))
                        
                        if self.isNumbers {
                            self.generatedPassword = randomPasswordWithNumbers(length: Int(self.passwordLength))
                        }
                        if self.isSymbols {
                            self.generatedPassword = randomPasswordWithSymbols(length: Int(self.passwordLength))
                        }
                        if self.isSymbols && self.isNumbers {
                            self.generatedPassword = randomPasswordWithAll(length: Int(self.passwordLength))
                        }
                        
                    }) {
                        Text("Generate").font(.system(.body, design: .rounded))
                    }
                    Button(action: {
                        self.hapticGen.simpleSuccess()
                        UIPasteboard.general.string = self.generatedPassword
                        self.showCopyNote = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now())
                        {
                            withAnimation { copiedString = "Password Copied!" }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
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
}

enum NumsOrMixed: String, CaseIterable {
    case nums = "Numbers"
    case mixed = "Mixed"
}

// MARK: PasswordGenView Functions
func NoDecimal(number: Double) -> String
{
    return String(format: "%.0f", number)
}

func generateRandomPassword(length: Int, characterSet: String) -> String {
    return String((0..<length).map { _ in characterSet.randomElement()! })
}

let uppercaseLetters = "QWERTYUIOPLKJHGFDSAZXCVBNM"
let lowercaseLetters = "qwertyuioplkjhgfdsazxcvbnm"
let numbers = "0123456789"
let symbols = "!@£$%^&*()-_?}{:;.,/"

func randomPasswordWithUppercaseLowercase(length: Int) -> String {
    let letters = uppercaseLetters + lowercaseLetters
    return generateRandomPassword(length: length, characterSet: letters)
}

func randomPasswordWithNumbers(length: Int) -> String {
    let letters = uppercaseLetters + lowercaseLetters + numbers
    return generateRandomPassword(length: length, characterSet: letters)
}

func randomPasswordJustNumbers(length: Int) -> String {
    let letters = numbers
    return generateRandomPassword(length: length, characterSet: letters)
}

func randomPasswordWithSymbols(length: Int) -> String {
    let letters = uppercaseLetters + lowercaseLetters + symbols
    return generateRandomPassword(length: length, characterSet: letters)
}

func randomPasswordWithAll(length: Int) -> String {
    let letters = uppercaseLetters + lowercaseLetters + numbers + symbols
    return generateRandomPassword(length: length, characterSet: letters)
}

// MARK: Preview
struct PasswordGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView()
    }
}
