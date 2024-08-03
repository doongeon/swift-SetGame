//
//  SetGameCard.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import Foundation

struct SetGame {
    private(set) var deck: Array<Card>
    private(set) var choices: Array<Card>
    private(set) var chosenCardIndecies: Array<Int> = []
    
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
    
    mutating func choose(_ card: Card) -> Void {
        if let chosenIndex = choices.firstIndex(where: { $0.id == card.id }) {
            choices[chosenIndex].isSelected.toggle()
        }
    }
    
    struct Card: Equatable, Identifiable {
        let color: CardTheme.colors
        let numOfShape: CardTheme.numOfShape
        let content: CardTheme.contents
        let shade: CardTheme.shades
        
        var isSet: Bool = false
        var isSelected: Bool = false
        
        var id: String
    }
}
