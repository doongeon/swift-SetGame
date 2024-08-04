//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import Foundation

class ShapeSetGame: ObservableObject {
    private var cardTheme: CardTheme
    @Published private var setGame: SetGame
    
    init() {
        cardTheme = CardTheme()
        self.setGame = SetGame(cardTheme.deckGenerator)
    }
    
    var choices: Array<SetGame.Card> {
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
    
    func choose(_ card: SetGame.Card) {
        setGame.choose(card)
    }
    
    func cheat() -> Void  {
        setGame.cheat()
    }
}
