//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import Foundation

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame.Card
    
    private var cardTheme: CardTheme
    @Published private var setGame: SetGame
    
    init() {
        cardTheme = CardTheme()
        self.setGame = SetGame(cardTheme.deckGenerator)
    }
    
    var deck: Array<Card> {
        setGame.deck
    }
    
    var deckCount: Int {
        setGame.deck.count
    }
    
    var hand: Array<Card> {
        setGame.hand
    }
    
    var dummy: Array<Card> {
        setGame.dummy
    }
    
    var isSet: Bool {
        if(setGame.cheatSet.count == 0) {
            false 
        } else {
            true
        }
    }
    
    var score: Int {
        setGame.score
    }
    
    // MARK: - Intents
    
    func firstDeal() {
        setGame.firstDeal()
    }
    
    func faceUp(card: Card) -> Void {
        setGame.faceUp(card: card)
    }
    
    func faceDown(card: Card) -> Void {
        setGame.faceDown(card: card)
    }
    
    func shuffle() {
        setGame.shuffle()
    }
    
    func draw() -> Array<Card.ID> {
        setGame.draw()
    }
    
    func choose(_ card: Card) -> Array<Card.ID> {
        setGame.choose(card)
    }
    
    func cheat() -> Void  {
        setGame.cheat()
    }
}
