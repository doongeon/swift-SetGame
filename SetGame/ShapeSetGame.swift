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
    
    var choices: Array<Card> {
        setGame.choices
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
    
    func newGame() {
        self.setGame = SetGame(cardTheme.deckGenerator)
    }
    
    func draw() {
        setGame.draw()
    }
    
    func choose(_ card: Card) {
        setGame.choose(card)
    }
    
    func cheat() -> Void  {
        setGame.cheat()
    }
}
