//
//  WaveView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 30/06/2023.
//

import Foundation
import SwiftUI

struct WaveView: View {
    
    @State var isAnimated:Bool = false
    @Binding var baselineAdjustment:CGFloat
    @Binding var amplitudeAdjustment:CGFloat
    @Binding var animationDuration:Double
    @Binding var waveColour: Color
    @Binding var opacity:Double
    
    var body: some View {
        
        Waves(isAnimated: isAnimated,
              baselineAdjustment: $baselineAdjustment,
              amplitudeAdjustment: $amplitudeAdjustment,
              animationDuration: $animationDuration,
              waveColour: $waveColour,
              opacity: $opacity)
    }
}

// MARK: Wave Creation
func Wave(interval: CGFloat, amplitude: CGFloat = 100, baseline: CGFloat = UIScreen.main.bounds.height/2) -> Path {
    Path { path in
        path.move(to: CGPoint(x: 0, y: baseline))
        path.addCurve(
            to: CGPoint(x: 1 * interval, y: baseline),
            control1: CGPoint(x: interval * (0.35), y: amplitude + baseline),
            control2: CGPoint(x: interval * (0.65), y: -amplitude + baseline))
        path.addCurve(
            to: CGPoint(x: 2 * interval, y: baseline),
            control1: CGPoint(x: interval * (1.35), y: amplitude + baseline),
            control2: CGPoint(x: interval * (1.65), y: -amplitude + baseline))
        path.addLine(to: CGPoint(x: 2 * interval, y: UIScreen.main.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.height))
    }
}

struct Waves: View {
    
    @State var isAnimated:Bool = false
    @Binding var baselineAdjustment:CGFloat
    @Binding var amplitudeAdjustment:CGFloat
    @Binding var animationDuration:Double
    @Binding var waveColour: Color
    @Binding var opacity:Double
    
    let universalSize = UIScreen.main.bounds
    var body: some View {
        ZStack {
            // close
            Wave(interval: universalSize.width, amplitude: amplitudeAdjustment, baseline: universalSize.height/baselineAdjustment)
                .foregroundColor(waveColour.opacity(opacity))
                .offset(x: isAnimated ? -1 * universalSize.width : 0)
                .animation(Animation.linear(duration: animationDuration + 2).repeatForever(autoreverses: false))
            
            Wave(interval: universalSize.width * 2, amplitude: amplitudeAdjustment - 20, baseline: universalSize.height/baselineAdjustment)
                .foregroundColor(waveColour.opacity(opacity + 0.2))
                .offset(x: isAnimated ? -1 * (universalSize.width * 2) : 0)
                .animation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false))
            
            // far
            Wave(interval: universalSize.width * 4, amplitude: amplitudeAdjustment - 40, baseline: 40 + universalSize.height/baselineAdjustment)
                .foregroundColor(waveColour.opacity(opacity + 0.4))
                .offset(x: isAnimated ? -1 * (universalSize.width * 4) : 0)
                .animation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false))
            
        }
        .onAppear {
            isAnimated = true
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // tufts blue - 7
            WaveView(baselineAdjustment: Binding.constant(3), amplitudeAdjustment: Binding.constant(100), animationDuration: Binding.constant(4),
                     waveColour: .constant(.standbyColour), opacity: Binding.constant(0.4))
        }
    }
}
