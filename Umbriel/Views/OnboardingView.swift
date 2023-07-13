//
//  OnboardingView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 11/07/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        TabView {
            
            OnboardPageView(title: "Welcome to Umbriel! 🙋🏻‍♂️", message: "A modern password manager, with a modern and fluid UI!", imageName: "house.lodge.fill", imageColour: .standbyColour, isDismissButtonShowing: false, isSkipButtonShowing: true, shouldShowOnboarding: $shouldShowOnboarding)
            
            OnboardPageView(title: "A test of strength! 💪🏼", message: "Test the strength of a password using the wave animations as a sign of its strength. Use the password tips to improve where needed!", imageName: "figure.strengthtraining.traditional", imageColour: .weakColour, isDismissButtonShowing: false, isSkipButtonShowing: true, shouldShowOnboarding: $shouldShowOnboarding)
            
            OnboardPageView(title: "Can't think? 🤔", message: "Use the password generator to create a password for you! Customise the length, use of symbols and numbers to get the right password for you!", imageName: "wand.and.stars", imageColour: .vStrongColour, isDismissButtonShowing: false, isSkipButtonShowing: true, shouldShowOnboarding: $shouldShowOnboarding)
            
            OnboardPageView(title: "Safe and sound! 🔐", message: "Keep your passwords at hand safely using the integrated Vault that encrypts the data and is locked behind your FaceID or TouchID credentials!", imageName: "lock.shield.fill", imageColour: .averageColour, isDismissButtonShowing: false, isSkipButtonShowing: true, shouldShowOnboarding: $shouldShowOnboarding)
            
            OnboardPageView(title: "That's all to it! 😊", message: "Come on in and start securing and protecting your data now!", imageName: "checkmark.shield.fill", imageColour: .strongColour, isDismissButtonShowing: true, isSkipButtonShowing: false, shouldShowOnboarding: $shouldShowOnboarding)
            
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardPageView: View {
    
    let title: String
    let message: String
    let imageName: String
    let imageColour: Color
    let isDismissButtonShowing: Bool
    let isSkipButtonShowing: Bool
    
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .foregroundColor(imageColour)
                .padding()
            
            Text(title)
                .font(.system(.largeTitle, design: .rounded))
                .padding()
            
            Text(message)
                .font(.system(.body, design: .rounded))
                .multilineTextAlignment(.center)
                .padding()
            
            if isDismissButtonShowing {
                Button(action: {
                    shouldShowOnboarding.toggle()
                }) {
                    Text("Enter")
                        .font(.system(size: 20, design: .rounded))
                }
                .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width/1.2)
                .padding()
                .foregroundColor(.white)
                .background(Color.init(red: 58/255, green: 146/255, blue: 236/255))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            if isSkipButtonShowing {
                Button(action: {
                    shouldShowOnboarding.toggle()
                }) {
                    Text("Skip")
                        .font(.system(size: 16, design: .rounded))
                }
                .padding()
                .foregroundColor(.black)
                .opacity(0.2)
            }
        }
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    @Binding var shouldShowOnboarding: Bool
//    static var previews: some View {
//        OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
//    }
//}
