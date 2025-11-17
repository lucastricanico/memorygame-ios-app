//
//  GameLogicTests.swift
//  MemoryGameTests
//
//  Created by Lucas Lopez.
//

import XCTest
@testable import MemoryGame

final class GameLogicTests: XCTestCase {

    func testImageMatching() {
        let url = URL(string: "https://example.com/image.png")!

        let c1 = Card(content: Card.Content.image(url), isFaceUp: true)
        let c2 = Card(content: Card.Content.image(url), isFaceUp: true)

        let vm = GameViewModel()
        XCTAssertTrue(vm.testing_isMatching(c1, c2))
    }

    func testImageNotMatching() {
        let c1 = Card(content: Card.Content.image(URL(string: "https://a.com/1.png")!))
        let c2 = Card(content: Card.Content.image(URL(string: "https://a.com/2.png")!))

        let vm = GameViewModel()
        XCTAssertFalse(vm.testing_isMatching(c1, c2))
    }

    func testSymbolMatching() {
        let c1 = Card(content: Card.Content.symbol("star"))
        let c2 = Card(content: Card.Content.symbol("star"))

        let vm = GameViewModel()
        XCTAssertTrue(vm.testing_isMatching(c1, c2))
    }

    func testSetCards() {
        let deck = [
            Card(content: Card.Content.symbol("a")),
            Card(content: Card.Content.symbol("a"))
        ]

        let vm = GameViewModel()
        vm.testing_setCards(deck)

        XCTAssertEqual(vm.cards.count, 2)
        XCTAssertEqual(vm.cards[0].content, Card.Content.symbol("a"))
    }
}
