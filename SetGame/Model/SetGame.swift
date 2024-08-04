//
//  SetGameCard.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import Foundation

struct SetGame {
    private(set) var score: Int = 0
    private(set) var deck: Array<Card>
    private(set) var choices: Array<Card>
    private(set) var cheatSet: Array<Int> = []
    
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
        calculateCorrectSet()
        
        if(cheatSet.count != 0) {
            score -= 1
        }
        
        for _ in 0..<3 {
            if let popedCard = deck.popLast() {
                choices.append(popedCard)
            }
        }
    }
    
    mutating func choose(_ card: Card) -> Void {
        if let chosenIndex = choices.firstIndex(where: { $0.id == card.id }) {
            let selectedCards = choices.filter({ $0.isSelected })
            if selectedCards.count > 2 {
                let isColorSet = checkColor(selectedCards: selectedCards)
                let isContentSet = checkContent(selectedCards: selectedCards)
                let isNumOfShapeSet = checkNumOfShape(selectedCards: selectedCards)
                let isShadeSet = checkShade(selectedCards: selectedCards)
                
                if (isColorSet && isContentSet && isNumOfShapeSet && isShadeSet) {
                    // correct set
                    selectedCards.forEach { selectedCard in
                        if let setIndex = choices.firstIndex(where: { choice in choice.id == selectedCard.id}) {
                            choices.remove(at: setIndex)
                        }
                    }
                    score += 3
                    
                    for _ in 0..<3 {
                        if let popedCard = deck.popLast() {
                            choices.append(popedCard)
                        }
                    }
                    
                } else {
                    // wrong set
                    selectedCards.forEach { selectedCard in
                        if let setIndex = choices.firstIndex(where: { choice in choice.id == selectedCard.id}) {
                            choices[setIndex].isSelected = false
                        }
                    }
                    
                    score -= 1
                }
            }
            choices[chosenIndex].isSelected.toggle()
        }
    }
    
    mutating func cheat() -> Void {
        calculateCorrectSet()
        
        if(cheatSet.count != 0) {
            cheatSet.forEach({index in choices[index].isCheatSet = true })
        }
    }
    
    private mutating func calculateCorrectSet() -> Void {
        cheatSet = []
        
        for i in 0..<choices.count {
            for j in (i+1)..<choices.count {
                for k in (j+1)..<choices.count {
                    let tempSet = [choices[i], choices[j], choices[k]]
                    
                    let isColorSet = checkColor(selectedCards: tempSet)
                    let isContentSet = checkContent(selectedCards: tempSet)
                    let isNumOfShapeSet = checkNumOfShape(selectedCards: tempSet)
                    let isShadeSet = checkShade(selectedCards: tempSet)
                    
                    if (isColorSet && isContentSet && isNumOfShapeSet && isShadeSet) {
                        cheatSet = [i, j, k]
                        return
                    }
                }
            }
        }
        
        print("there is no set")
    }
    
    private func checkColor(selectedCards: Array<Card>) -> Bool {
        if(
            selectedCards[0].color == selectedCards[1].color &&
            selectedCards[0].color == selectedCards[2].color
        ) {
            return true
        } else if(
            selectedCards[0].color != selectedCards[1].color &&
            selectedCards[0].color != selectedCards[2].color &&
            selectedCards[1].color != selectedCards[2].color
        ) {
            return true
        } else {
//            print("color not set")
            return false
        }
    }
    
    private func checkShade(selectedCards: Array<Card>) -> Bool {
        if(
            selectedCards[0].shade == selectedCards[1].shade &&
            selectedCards[0].shade == selectedCards[2].shade
        ) {
            return true
        } else if(
            selectedCards[0].shade != selectedCards[1].shade &&
            selectedCards[0].shade != selectedCards[2].shade &&
            selectedCards[1].shade != selectedCards[2].shade
        ) {
            return true
        } else {
//            print("shade not set")
            return false
        }
    }
    
    private func checkContent(selectedCards: Array<Card>) -> Bool {
        if(
            selectedCards[0].content == selectedCards[1].content &&
            selectedCards[0].content == selectedCards[2].content
        ) {
            return true
        } else if(
            selectedCards[0].content != selectedCards[1].content &&
            selectedCards[0].content != selectedCards[2].content &&
            selectedCards[1].content != selectedCards[2].content
        ) {
            return true
        } else {
//            print("content not set")
            return false
        }
    }
    
    private func checkNumOfShape(selectedCards: Array<Card>) -> Bool {
        if(
            selectedCards[0].numOfShape == selectedCards[1].numOfShape &&
            selectedCards[0].numOfShape == selectedCards[2].numOfShape
        ) {
            return true
        } else if(
            selectedCards[0].numOfShape != selectedCards[1].numOfShape &&
            selectedCards[0].numOfShape != selectedCards[2].numOfShape &&
            selectedCards[1].numOfShape != selectedCards[2].numOfShape
        ) {
            return true
        } else {
//            print("shape not set")
            return false
        }
    }
    
    struct Card: Equatable, Identifiable {
        let color: CardTheme.colors
        let numOfShape: CardTheme.numOfShape
        let content: CardTheme.contents
        let shade: CardTheme.shades
        
        var isCheatSet: Bool = false
        var isSet: Bool = false
        var isSelected: Bool = false
        
        var id: String
    }
}
