//
//  CardView.swift
//  MemoryGame
//
//  Created by Lucas Lopez.
//

import SwiftUI

/// Visual representation of a single memory-game card.
struct CardView: View {
    let card: Card
    
    private let cardSize: CGFloat = 110
    
    var body: some View {
        ZStack {
            // Background (always kept under image)
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(card.isFaceUp ? Color(.systemBackground) : Color.accentColor)
                .shadow(radius: card.isFaceUp ? 2 : 4)
            
            // Border
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.secondary.opacity(card.isFaceUp ? 0.4 : 0.15), lineWidth: 1)
            
            Group {
                if card.isFaceUp {
                    faceUpContent
                } else {
                    Image(systemName: "questionmark")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .clipped()
        }
        
        // Lock the card to a perfect square regardless of image
        .frame(width: cardSize, height: cardSize)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: card.isFaceUp)
        .scaleEffect(card.isMatched ? 0.98 : 1)
        .rotation3DEffect(.degrees(card.isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
    
    // MARK: - Face-Up Content
    @ViewBuilder
    private var faceUpContent: some View {
        GeometryReader { geo in
            switch card.content {
                
            case .image(let url):
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    case .empty:
                        ProgressView()
                            .frame(width: geo.size.width, height: geo.size.height)
                    case .failure(_):
                        Color.gray
                            .frame(width: geo.size.width, height: geo.size.height)
                    @unknown default:
                        Color.gray
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                
            case .symbol(let name):
                Image(systemName: name)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: geo.size.width, height: geo.size.height)
                
            case .qa(let question, let answer, let showsQuestion):
                VStack(spacing: 6) {
                    Text(showsQuestion ? question : answer)
                        .font(.system(size: 14, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                        .lineLimit(4)
                    
                    Text(showsQuestion ? "Question" : "Answer")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}
