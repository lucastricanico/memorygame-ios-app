# NYC Landmark Memory Game - iOS Matching Game
*by Lucas Lopez*

*Modern Memory game featuring NYC landmark images fetched from Back4App, built with SwiftUI, async/await networking, and clean MVVM architecture.*

<p align="left">

  <img src="https://img.shields.io/badge/iOS-17+-lightgrey?style=for-the-badge" />
  <img src="https://img.shields.io/badge/SwiftUI-Ready-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Swift_Concurrency-async%2Fawait-yellow?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Architecture-MVVM_+_ObservableObject-informational?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Networking-URLSession_+_Back4App-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Unit_Tests-Included-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />


</p>

---

## Demo  

<p align="center">
  <img src="Screenshots/demo.gif" width="350" alt="MemoryGame Demo" />
</p>

---

## Overview  
**NYC Landmark Memory** is a SwiftUI matching game where players flip cards and try to match pairs of NYC landmarks. This project applies iOS patterns:

- SwiftUI first architecture
- Swift Concurrency (async/await)
- ObservableObject + @Published state management
- Clean MVVM separation
- Isolated API layer for Back4App requests
- Unit tests for the core matching algorithm and deck setup

---

## Tech Stack

<p align="left">

   <img src="https://img.shields.io/badge/Swift-FA7343?logo=swift&logoColor=white&style=for-the-badge" />
  <img src="https://img.shields.io/badge/SwiftUI-0A84FF?logo=swift&logoColor=white&style=for-the-badge" />
  <img src="https://img.shields.io/badge/Concurrency-MainActor_%7C_async%2Fawait-yellow?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Networking-URLSession-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/API-Back4App_Parse-success?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Tests-Unit_Tests-blue?style=for-the-badge" />


</p>

---

## Features  

### Core Gameplay
- Flip cards to reveal images
- Match all pairs to win
- Smooth 3D flip animations and opacity transitions
- Win tracker with move counter
- Support for 2, 4, 6, or 8 pairs

### UI & Interaction
- Animated intro/splash screen
- Spring animations on flips & reveals
- Adaptive LazyVGrid layout
- Smooth match/dismiss animations

### API Integration
- Fetches real landmark data from Back4App
- Each card shows its corresponding NYC landmark photo
- Automatic fallback to SF Symbols if API is unavailable

## Networking
- Uses async/await with URLSession
- Decodes Back4App Parse schema
- Thread-safe @MainActor updates
- Graceful API failure fallback

## Unit Testing
- Tests for all matching logic
- Tests for symbol matches, image matches, and deck injection
- Debug-only ViewModel helpers for testability

---

## Screenshots  

<p align="center">
  <img src="Screenshots/start_screen .png" width="280" alt="Start Screen" />
  <img src="Screenshots/game_screen .png" width="280" alt="Game Screen" />
</p>

<p align="center">
  <em>Left: Start Game screen | Right: Gameplay screen</em>
</p>

---

## Architecture

This project follows a clean and simple **MVVM architecture** optimized for SwiftUI.
Views are declarative, the ViewModel owns all game logic and state, and the Model layer remains lightweight and serializable.

---

### MVVM Overview

| Layer | Responsibility |
|-------|---------------|
| **Model** | Defines core data (Card, Landmark) with no application logic. |
| **ViewModel (`GameViewModel`)** | Handles shuffling, matching logic, move counting, and async image loading. |
| **Views** | SwiftUI screens (grid, cards, intro overlay) reacting to state changes. |

---

### 1. Models

The model layer includes

- `Card` — symbol/image content, matched state, face-up state
- `Landmark` — Back4App-parsed NYC landamrk (id, name, imageURL)

These structs contain data only, no logic.

---

### 2. ViewModel (`GameViewModel`)

Heart of App:

#### **Game Logic**
- Handles first/second selection flow
- Determines whether two cards match
- Applies appropriate delays for match/mismatch
- Tracks moves and win condition

#### **Deck Creation**
- Creates paired cards from Back4App image URLs
- Falls back to SF Symbols
- Shuffles and resets cleanly

#### **Networking**
- Loads landmark metadata on launch
- Uses async/await + @MainActor
- Centralized LandmarkAPI service  

#### **Testability**
Includes debug-only exposed helpers:
- testing_isMatching()
- testing_setCards()

---

### 3. Views

#### **ContentView**
- Main game screen
- Pair picker, reset button, move counter
- LazyVGrid layout for cards
- Win banner

#### **CardView**
- Flip animation
- Image, SF Symbol, or content placeholder
- Rounded card style matching iOS 17 aesthetic

#### **IntroView**
- Animated launch overlay with title + start button

---

### 4. Networking (`LandmarkAPI`)

The API layer provides a clean async interface:
- Fetches Landmark list from Back4App Parse API
- Decodes nested image file objects
- Returns an empty list on failure
- Keeps networking separate from game logic

---

### 5. Unit Testing

A dedicated GameLogicTests.swift suite validates:

- Image matching
- Symbol matching
- Non-matching cases
- Deck replacement injection

**Example Test:**

```bash
func testSymbolMatching() {
    let c1 = Card(content: .symbol("star"))
    let c2 = Card(content: .symbol("star"))

    let vm = GameViewModel()
    XCTAssertTrue(vm.testing_isMatching(c1, c2))
}
```
---

## Installation

### Requirements
- Xcode 15+  
- iOS 17+  
- Swift 5.9  

### Steps
1. Clone the repo
    ```bash
    git clone https://github.com/lucastricanico/memorygame-ios-app.git
    ```
2. Open in Xcode
3. Run the Project
4. Have FUN!

---

## Project Structure
```bash
NYCLandmarkMemory/
│
├── Models/
│   ├── Card.swift
│   └── Landmark.swift
│
├── Services/
│   └── LandmarkAPI.swift
│
├── ViewModels/
│   └── GameViewModel.swift
│
├── Views/
│   ├── CardView.swift
│   ├── ContentView.swift
│   └── IntroView.swift
│
├── Tests/
│   └── GameLogicTests.swift
│
├── Screenshots/
│   ├── demo.gif
│   ├── start_screen .png
│   └── game_screen .png
│
├── Assets.xcassets
├── MemoryGame.swift
├── README.md
└── LICENSE
```

---

## Credits 
This project uses public image firl URLs provided through Back4App.

This project is non-commercial and built for learning + portfolio purposes.

All NYC landmark imagery belongs to their respective owners.

---

## Future Improvements
### Gameplay
- Difficulty modes
- Timed rounds
- Animated flips (3D rotation with matched removal)

### UX Enhancements
- Haptic feedback
- Improved loading placeholders
- Larger grid layouts (4×4, 5×5)

### API + Data
- Landmark metadata sheet
- Caching of fetched images
- Offline-first fallback options

---

## License
Released under the MIT License.

See LICENSE for details.
