//
//  SetGameCard.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import Foundation

struct SetGame<CardContent> {
    private(set) var deck: Array<Card>
    private(set) var choices: Array<Card>
    
    init(_ deckGenerator: () -> Array<Card>) {
        self.deck = deckGenerator()
        self.choices = []
        
        for _ in 0..<12 {
            if let popedCard = deck.popLast() {
                choices.append(popedCard)
            }
        }
    }
    
    mutating func draw() -> Void {
        for _ in 0..<3 {
            if let popedCard = deck.popLast() {
                choices.append(popedCard)
            }
        }
    }
    
    func choose(_ card: Card) -> Void {
        print(card)
    }
    
    struct Card: Identifiable {
        let color: String
        let count: Int
        let content: CardContent
        let shade: String
        
        var id: String
    }
}
