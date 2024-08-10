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
    private(set) var hand: Array<Card>
    private(set) var cheatSet: Array<Int> = []
    private(set) var dummy: Array<Card> = []
    
    init(_ deckGenerator: () -> Array<Card>) {
        self.deck = deckGenerator()
        self.hand = []
    }
    
    mutating func firstDeal() -> Void {
        for _ in 0..<12 {
            if let  popedCard = deck.popLast() {
                hand.append(popedCard)
            }
        }
    }
    
    mutating func faceUp(card: Card) -> Void {
        if let indexOfCard = hand.firstIndex(where: {$0.id == card.id}) {
            hand[indexOfCard].isFaceUp = true 
        }
    }
    
    mutating func faceDown(card: Card) -> Void {
        if let indexOfCard = hand.firstIndex(where: {$0.id == card.id}) {
            hand[indexOfCard].isFaceUp = false
        }
    }
    
    mutating func shuffle() -> Void {
        while !hand.isEmpty {
            deck.append(hand.popLast()!)
        }
        while !dummy.isEmpty {
            deck.append(dummy.popLast()!)
        }
        deck.shuffle()
    }
    
    mutating func draw() -> Array<Card.ID> {
        if(deck.isEmpty) { return [] }
        
        calculateCorrectSet()
        
        if(cheatSet.count > 0) {
            score -= 1
        }
        
        var result: Array<Card.ID> = []
        
        for _ in 0..<3 {
            if let popedCard = deck.popLast() {
                hand.append(popedCard)
                result.append(popedCard.id)
            }
        }
        
        return result
    }
    
    mutating func cheat() -> Void {
        calculateCorrectSet()
        if(cheatSet.count != 0) {
            cheatSet.forEach({index in hand[index].isCheatSet = true })
        }
    }
    
    private mutating func calculateCorrectSet() -> Void {
        cheatSet = []
        
        for i in 0..<hand.count {
            for j in (i+1)..<hand.count {
                for k in (j+1)..<hand.count {
                    if isValidateSet([hand[i], hand[j], hand[k]]) {
                        cheatSet = [i, j, k]
                        return
                    }
                }
            }
        }
        
//        print("there is no set")
    }
    
    mutating func choose(_ card: Card) -> Array<Card.ID> {
        if let chosenIndex = hand.firstIndex(where: { $0.id == card.id }) {
            hand[chosenIndex].isSelected.toggle()
            let popedCards = eraseSettedCards()
            let selectedCards = hand.filter({ $0.isSelected })
            validate (selectedCards)
            
            return popedCards
        }
        return []
    }
    
    mutating func validate (_ selectedCards: Array<Card>) -> Void {
        if selectedCards.count < 3 { return }
            
        if (isValidateSet(selectedCards)) {
            // set is correct
            markMatch()
            score += 3
        } else {
            // set is wrong
            clearSelection()
            score -= 1
        }
        
        func markMatch() -> Void {
            selectedCards.forEach { selectedCard in
                if let setIndex = hand.firstIndex(where: { choice in choice.id == selectedCard.id}) {
                    hand[setIndex].isSet = true;
                }
            }
        }
        
        func clearSelection() -> Void {
            selectedCards.forEach { selectedCard in
                if let setIndex = hand.firstIndex(where: { choice in choice.id == selectedCard.id}) {
                    hand[setIndex].isSelected = false
                }
            }
        }
    }
    
    mutating private func eraseSettedCards() -> Array<Card.ID> {
        let settedCard = hand.filter({ $0.isSet })
        var popedCards : Array<Card.ID> = []
        settedCard.forEach { card in
            if let indexOfSettedCard = hand.firstIndex(where: { choice in
                choice.id == card.id
            }) {
                if var popedCard = deck.popLast() {
                    popedCard.isFaceUp = true
                    popedCards.append(popedCard.id)
                    dummy.append(hand[indexOfSettedCard].dummify())
                    hand[indexOfSettedCard] = popedCard
                } else {
                    hand.remove(at: indexOfSettedCard)
                }
            }
            
        }
        
        return popedCards
    }
    
    private func isValidateSet(_ selectedCards: Array<Card>) -> Bool {
        let isColorSet = checkColor(selectedCards: selectedCards)
        let isContentSet = checkContent(selectedCards: selectedCards)
        let isNumOfShapeSet = checkNumOfShape(selectedCards: selectedCards)
        let isShadeSet = checkShade(selectedCards: selectedCards)
        
        if (isColorSet && isContentSet && isNumOfShapeSet && isShadeSet) {
            return true
        } else  {
            return false
        }
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
        
        var isFaceUp: Bool = false 
        var isCheatSet: Bool = false
        var isSet: Bool = false
        var isSelected: Bool = false
        
        let id: String
        
        mutating func dummify() -> Card  {
            isFaceUp = true
            isCheatSet = false
            isSet = true 
            isSelected = false
            
            return self
        }
        
        mutating func reset() -> Card  {
            isFaceUp = false
            isCheatSet = false
            isSet = false
            isSelected = false
            
            return self
        }
    }
}
