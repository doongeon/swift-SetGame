//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import Foundation

class ShapeSetGame: ObservableObject {
    private var theme: CardTheme<String>
    @Published private var setGame: SetGame<String>
    
    init() {
        theme = CardTheme(
            colors: ["red", "green", "blue"],
            contents: ["circle", "square", "triangle"]
        )
        self.setGame = SetGame<String>(theme.deckGenerator)
    }
    
    var choices: Array<SetGame<String>.Card> {
        setGame.choices
    }
    
    // MARK: - Intents
    
    func draw() {
        setGame.draw()
    }
    
    func choose(_ card: SetGame<String>.Card) {
        setGame.choose(card)
    }
}
