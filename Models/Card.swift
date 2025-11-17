//
//  Card.swift
//  MemoryGame
//
//  Created by Lucas Lopez.
//

import Foundation

/// Represents a single card in the memory game.
///
/// The `content` defines what is shown on the face of the card.
/// Cards can currently be:
/// - a system symbol
/// - a Q&A pair (question / answer)
/// - an image loaded from a URL.
struct Card: Identifiable, Equatable {

    /// The type of content displayed on a card.
    enum Content: Equatable {
        /// A system SF Symbol name (e.g. "star.fill").
        case symbol(String)

        /// A question/answer pair, with a flag for which side is shown.
        case qa(question: String, answer: String, showsQuestion: Bool)

        /// An image loaded from a remote URL.
        case image(URL)
    }

    /// Stable identity so SwiftUI can diff and animate cards.
    let id = UUID()

    /// The content shown on this card when it is face up.
    var content: Content

    /// Whether the card is currently face up.
    var isFaceUp: Bool = false

    /// Whether this card has been successfully matched and removed.
    var isMatched: Bool = false
}

// MARK: - Factory helpers

extension Card {

    /// Create a pair of identical symbol cards.
    static func pairFromSymbol(_ name: String) -> [Card] {
        [
            Card(content: .symbol(name)),
            Card(content: .symbol(name))
        ]
    }

    /// Helper to create a matching pair of image cards.
    static func pairFromImageURL(_ url: URL) -> [Card] {
        [
            Card(content: .image(url)),
            Card(content: .image(url))
        ]
    }
}
