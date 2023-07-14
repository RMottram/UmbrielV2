//
//  ContentView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 30/06/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //@Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedTab = 0
    
    var passwordTester = PasswordLogic()
    var hapticGen = Haptics()
    
    @State var shouldShowOnboarding = true // change to @AppStorage to persist bool value
    @State private var isInfoView = false
    @State private var showCopyNote = false
    @State private var password = ""
    @State private var isHidden = false
    @State private var score: Double = 0
    @State private var isStandby = true
    @State private var isWeak = false
    @State private var isAverage = false
    @State private var isStrong = false
    @State private var isVeryStrong = false
    
    @State private var standby = Color.standbyColour
    @State private var weak = Color.weakColour
    @State private var average = Color.averageColour
    @State private var strong = Color.strongColour
    @State private var vStrong = Color.vStrongColour
    @State private var opacity:Double = 0.2
    
    // wave properties
    @State private var baseline:CGFloat = UIScreen.main.bounds.height/100
    @State private var amplitude:CGFloat = 40
    @State private var animationDuration:Double = 4
    
    var body: some View
    {
        
        TabView(selection: $selectedTab)
        {
            
            // MARK: Text Fields and Buttons
            VStack
            {
                NotificationBannerView()
                    .offset(x: self.showCopyNote ? UIScreen.main.bounds.width/3 : UIScreen.main.bounds.width)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 80, damping: 10, initialVelocity: 1))
                    .onTapGesture {
                        withAnimation {
                            self.showCopyNote = false
                        }
                    }
                    .onDisappear(perform: {
                        self.showCopyNote = false
                    })
                
                ZStack(alignment: .leading) {
                    
                    HStack {
                        Button(action: {
                            isInfoView.toggle()

                            // dismiss keyboard
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        })
                        {
                            Image(systemName: "info.circle")
                                .font(.largeTitle)
                                .foregroundColor(.standbyColour)
                        }
                        .offset(x: 20, y: -50)
                    }
                    .sheet(isPresented: $isInfoView) {
                        InfoView()
                    }
                    
                    HStack
                    {
                        if self.isHidden
                        {
                            SecureField("Enter Password...", text: self.$password, onCommit: {
                                self.TestPass()
                                self.hapticGen.simpleSuccess()
                            })
                            .padding(10)
                            .padding(.horizontal, 10).padding(.top, 20)
                            .font(.system(size: 20, design: .rounded))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.webSearch)
                        } else
                        {
                            TextField("Enter Password...", text: self.$password, onCommit: {
                                self.TestPass()
                                self.hapticGen.simpleSuccess()
                            })
                            .padding(10)
                            .padding(.horizontal, 10).padding(.top, 20)
                            .font(.system(size: 20, design: .rounded))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.webSearch)
                        }
                        
                        Button(action: {
                            self.isHidden.toggle()
                            self.TestPass()
                            self.hapticGen.simpleSelectionFeedback()
                        })
                        {
                            Image(systemName: self.isHidden ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.isHidden ? .weakColour : .strongColour)
                                .padding(.top, 30)
                        }
                        .ignoresSafeArea(.all)
                        Button(action: {
                            self.hapticGen.simpleSelectionFeedback()
                            self.TestPass()
                            UIPasteboard.general.string = self.password
                            self.showCopyNote = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4)
                            {
                                withAnimation { self.showCopyNote = false }
                            }
                            
                        })
                        {
                            Image(systemName: "doc.on.clipboard")
                                .foregroundColor(.standbyColour)
                                .padding(.top, 30).padding(.trailing, 25)
                            
                        }
                    }.padding(.top, 100)
                }
                
                Divider()
                    .padding(.horizontal, 20)
                
                // MARK: Wave Implementations
                
                ZStack
                {
                    if isWeak
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $weak, opacity: $opacity)
                    }
                    if isAverage
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $average, opacity: $opacity)
                    }
                    if isStrong
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $strong, opacity: $opacity)
                    }
                    if isVeryStrong
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $vStrong, opacity: $opacity)
                    }
                    if isStandby
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $standby, opacity: $opacity)
                    }
                }.padding(.top, 40)
            }
            .tabItem {
                Image(systemName: "figure.strengthtraining.traditional")
                Text("Strength Tester")
            }.tag(0)
            
            PasswordGeneratorView()
                .tabItem {
                    Image(systemName: "wand.and.stars")
                    Text("Password Generator")
                }.tag(1)
            
            TheVaultView()
                .tabItem {
                    Image(systemName: "lock.shield")
                    Text("TheVault")
                }.tag(2)
            
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding) {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        }
        .sheet(isPresented: $isInfoView) {
            InfoView()
        }
    }
    
    // MARK: ContentView Functions
    
    func TestPass() {
        
        switch self.passwordTester.TestStrength(password: self.password)
        {
            case .Blank:
                self.isStandby = true
                self.isWeak = false
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = false
            case .Weak:
                self.isStandby = false
                self.isWeak = true
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = false
            case .Average:
                self.isStandby = false
                self.isWeak = false
                self.isAverage = true
                self.isStrong = false
                self.isVeryStrong = false
            case .Strong:
                self.isStandby = false
                self.isWeak = false
                self.isAverage = false
                self.isStrong = true
                self.isVeryStrong = false
            case .VeryStrong:
                self.isStandby = false
                self.isWeak = false
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
