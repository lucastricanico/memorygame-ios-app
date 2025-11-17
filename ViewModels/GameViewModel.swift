//
//  GameViewModel.swift
//  MemoryGame
//
//  Created by Lucas Lopez.
//

import SwiftUI
import Foundation
import Combine

/// ViewModel managing the Memory Game state.
/// Loads NYC landmark images from Back4App, builds card pairs,
/// evaluates matches, tracks moves, and exposes UI state.
final class GameViewModel: ObservableObject {

    // MARK: - Back4App Keys
    private let appId = "ZPkjiCNd7MN1z1Bo4R2WuTMr8cbh0NTuI8TOP40v"
    private let apiKey = "Cjv9oEJjUlykb0GkQtkOSOWsZUwwYybTDRhIjqir"

    // MARK: - User Configuration
    @Published var availablePairs: [Int] = [2, 4, 6, 8]
    @Published var numberOfPairs: Int = 4 {
        didSet { resetGame() }
    }

    // MARK: - Game State
    @Published fileprivate(set) var cards: [Card] = []
    @Published private(set) var moves: Int = 0
    @Published private(set) var isProcessingPick: Bool = false

    private var firstSelectedIndex: Int? = nil
    private var remoteLandmarks: [Landmark] = []

    /// Whether all cards have been successfully matched.
    var isWin: Bool { cards.allSatisfy { $0.isMatched } && !cards.isEmpty }

    /// UI-friendly status text.
    var statusText: String {
        if isWin { return "Completed in \(moves) moves" }
        return "Moves: \(moves)  •  Pairs: \(numberOfPairs)"
    }

    // MARK: - Lifecycle
    init() {
        Task { await loadImages() }
    }

    // MARK: - API Loading

    /// Fetches NYC landmark images from Back4App.
    @MainActor
    private func loadImages() async {
        let items = await LandmarkAPI.fetchLandmarks(appId: appId, apiKey: apiKey)
        self.remoteLandmarks = items
        resetGame()
    }

    // MARK: - Game Setup

    /// Resets deck and creates a new shuffled set of image-based cards.
    func resetGame() {

        let source = remoteLandmarks.isEmpty
        ? []
        : Array(remoteLandmarks.shuffled().prefix(numberOfPairs))

        var newDeck: [Card] = []

        if !source.isEmpty {
            for item in source {
                newDeck.append(contentsOf: Card.pairFromImageURL(item.imageURL))
            }
        } else {
            let symbols = ["building.2", "tram.fill", "taxi", "ferry.fill", "bridge"]
            for sym in symbols.prefix(numberOfPairs) {
                newDeck.append(contentsOf: Card.pairFromSymbol(sym))
            }
        }

        newDeck.shuffle()

        withAnimation(.spring) {
            self.cards = newDeck
            self.moves = 0
            self.firstSelectedIndex = nil
            self.isProcessingPick = false
        }
    }

    // MARK: - Game Logic

    func handleTap(on index: Int) {
        guard !isProcessingPick else { return }
        guard cards.indices.contains(index) else { return }
        guard !cards[index].isMatched && !cards[index].isFaceUp else { return }

        withAnimation(.easeInOut(duration: 0.25)) {
            cards[index].isFaceUp = true
        }

        if let first = firstSelectedIndex {
            isProcessingPick = true
            moves += 1

            let isMatch = isMatching(cards[first], cards[index])
            let delay = isMatch ? 0.35 : 0.8

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if isMatch {
                    self.cards[first].isMatched = true
                    self.cards[index].isMatched = true
                } else {
                    self.cards[first].isFaceUp = false
                    self.cards[index].isFaceUp = false
                }
                self.firstSelectedIndex = nil
                self.isProcessingPick = false
            }

        } else {
            firstSelectedIndex = index
        }
    }

    /// Two image-cards match if their URLs are identical.
    private func isMatching(_ lhs: Card, _ rhs: Card) -> Bool {
        switch (lhs.content, rhs.content) {
        case let (.image(url1), .image(url2)):
            return url1 == url2
        case let (.symbol(s1), .symbol(s2)):
            return s1 == s2
        default:
            return false
        }
    }
}

// MARK: - Test Helpers (Only for DEBUG/Test builds)
#if DEBUG
extension GameViewModel {

    /// Allows tests to access the private match logic.
    func testing_isMatching(_ lhs: Card, _ rhs: Card) -> Bool {
        isMatching(lhs, rhs)
    }

    /// Allows tests to override the deck.
    func testing_setCards(_ newCards: [Card]) {
        self.cards = newCards
    }
}
#endif
s
