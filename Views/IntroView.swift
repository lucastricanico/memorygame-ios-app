//
//  IntroView.swift
//  MemoryGame
//
//  Created by Lucas Lopez.
//

import SwiftUI

/// Splash / intro screen shown when the app launches.
struct IntroView: View {

    /// Whether the intro is currently visible.
    @Binding var isVisible: Bool

    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Text("NYC Landmark Memory")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Text("by Lucas Lopez")
                    .foregroundColor(.white.opacity(0.85))
                    .font(.subheadline)

                // Start button
                Button {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        isVisible = false
                    }
                } label: {
                    Text("Start Game")
                        .font(.headline)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .foregroundColor(.accentColor)
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .padding(.top, 16)
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.8), value: isVisible)
    }
}
