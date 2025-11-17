//
//  ContentView.swift
//  MemoryGame
//
//  Created by Lucas Lopez.
//

import SwiftUI

/// Main screen.
struct ContentView: View {
    @StateObject private var vm = GameViewModel()

    @State private var showIntro = true

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    }

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 12) {

                    // MARK: - Controls
                    HStack(spacing: 12) {
                        Picker("Pairs", selection: $vm.numberOfPairs) {
                            ForEach(vm.availablePairs, id: \.self) { count in
                                Text("\(count) pairs").tag(count)
                            }
                        }
                        .pickerStyle(.segmented)

                        Button(action: vm.resetGame) {
                            Label("New Game", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)

                    // MARK: - Status Text
                    Text(vm.statusText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // MARK: - Card Grid
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 12) {
                            ForEach(vm.cards.indices, id: \.self) { index in
                                CardView(card: vm.cards[index])
                                    .onTapGesture { vm.handleTap(on: index) }
                                    .opacity(vm.cards[index].isMatched ? 0 : 1)
                                    .animation(.easeInOut(duration: 0.25),
                                               value: vm.cards[index].isMatched)
                            }
                        }
                        .padding(12)
                    }

                    // MARK: - Win Banner
                    if vm.isWin {
                        VStack(spacing: 8) {
                            Text("You matched all landmarks!")
                                .font(.headline)
                            Button("Play Again", action: vm.resetGame)
                                .buttonStyle(.borderedProminent)
                        }
                        .padding(.bottom)
                    }
                }
                .navigationTitle("NYC Landmark Memory")
            }

            // MARK: - Intro Overlay
            if showIntro {
                IntroView(isVisible: $showIntro)
                    .transition(.opacity)
                    .zIndex(5)
            }
        }
    }
}

#Preview {
    ContentView()
}
