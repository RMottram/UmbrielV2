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
    @State private var animationDuration:Double = 6
    
    var body: some View {
        
        
        TabView(selection: $selectedTab) {
            
            // MARK: Text Fields and Buttons
            VStack {
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
                
                HStack
                {
                    TextField("Enter Password...", text: self.$password, onCommit: {
                        self.TestPass()
                        self.hapticGen.simpleSuccess()
                    })
                    .padding()
                    .padding(.horizontal, 10)
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.secondary.opacity(0.5))
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.webSearch)
                    
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
                        Image(systemName: "doc.on.doc.fill")
                            .resizable()
                            .frame(width: 20, height: 25)
                            .foregroundColor(.standbyColour)
                    }
                    .padding()
                }
                .padding()
                
                // MARK: Wave Implementations
                
                ZStack
                {
                    if isWeak
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $weak, opacity: $opacity)
                            .clipShape(Rectangle())
                    }
                    if isAverage
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $average, opacity: $opacity)
                            .clipShape(Rectangle())
                    }
                    if isStrong
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $strong, opacity: $opacity)
                            .clipShape(Rectangle())
                    }
                    if isVeryStrong
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $vStrong, opacity: $opacity)
                            .clipShape(Rectangle())
                    }
                    if isStandby
                    {
                        WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, waveColour: $standby, opacity: $opacity)
                            .clipShape(Rectangle())
                    }
                }.padding(.top, 40)
            }
            .tabItem {
                if #available(iOS 16.0, *) {
                    Image(systemName: "figure.strengthtraining.traditional")
                } else {
                    Image(systemName: "checkmark.shield.fill")
                }
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
        .accentColor(tabBarColor(for: selectedTab))
        .fullScreenCover(isPresented: $shouldShowOnboarding) {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        }
        .sheet(isPresented: $isInfoView) {
            InfoView()
        }
    }
    
    // MARK: ContentView Functions
    
    private func tabBarColor(for tab: Int) -> Color {
        switch tab {
        case 0:
            return .weakColour
        case 1:
            return .averageColour
        case 2:
            return .strongColour
        default:
            return .standbyColour
        }
    }
    
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
