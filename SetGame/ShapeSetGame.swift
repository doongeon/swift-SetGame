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
    
    // MARK: - Intents
    
    func draw() {
        setGame.draw()
    }
    
    func choose(_ card: SetGame.Card) {
        setGame.choose(card)
    }
}
