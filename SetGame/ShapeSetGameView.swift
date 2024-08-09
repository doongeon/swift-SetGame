//
//  ShapeSetGameView.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import SwiftUI

struct ShapeSetGameView: View {
    typealias Card = SetGame.Card
    @ObservedObject var shapeSetGame = ShapeSetGame()
    
    var body: some View {
        VStack {
            stat
            cards
            buttons
        }
        .padding()
        
    }
    
    var stat: some View {
        VStack(spacing: 5) {
            title
            score
        }
    }
    
    var title: some View  {
        Text("Set Game")
            .font(.largeTitle)
    }
    
    var score: some View  {
        Text("Score: \(shapeSetGame.score)")
            .font(.title3)
            .animation(nil)
    }
    
    var buttons: some View {
        HStack(alignment: .bottom, spacing: 40) {
            drawButton
            newgameButton
            cheatButton
        }
        .padding()
    }
    
    var drawButton: some View {
        Button(
            action: {
                let drawCardId = shapeSetGame.draw()
                var delay: TimeInterval = 0
                for id in drawCardId {
                    if let drawCard = shapeSetGame.choices.first(where: { $0.id == id } ) {
                        withAnimation(.easeInOut(duration: 1).delay(delay)) {
                            deal(card: drawCard)
                        }
                        delay += 0.1
                    }
                }
            }, label: {
                VStack(spacing: 5) {
                    deckView
                    Text("Draw")
                }
            }
        )
    }
    
    var newgameButton: some View {
        Button(action: {
            withAnimation() {
                shapeSetGame.newGame()
            }
            var delay: TimeInterval = 0
            for card in shapeSetGame.choices {
                withAnimation(.easeInOut(duration: 1).delay(delay)) {
                    deal(card: card)
                }
                delay += 0.1
            }
        }, label: {
            VStack(spacing: 5) {
                Image(systemName: "gamecontroller")
                    .font(.title)
                    .imageScale(.large)
                Text("New Game")
            }
        })
    }
    
    @Namespace private var dealingNameSpace
    
    var deckView: some View {
        ZStack {
            let cardWith: CGFloat = 50
            var offset: CGFloat = 0
            var computedOffset: CGFloat {
                get {
                    offset = offset + 0.05
                    return offset
                }
                set { offset = newValue }
            }
            
            ForEach(shapeSetGame.deck) { card  in
                let cardOffset = computedOffset
                CardView(card)
                    .offset(
                        x: cardOffset,
                        y: cardOffset
                    )
                    .zIndex(-cardOffset)
                    .shadow(radius: 0.1, x: 0.01, y: 0.01)
                    .frame(width: cardWith, height: cardWith / (2/3))
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
    }
    
    var cheatButton: some View {
        Button(action: {
            withAnimation {
                shapeSetGame.cheat()
            }
        }, label: {
            VStack(spacing: 5) {
                Image(systemName: "warninglight")
                    .font(.title)
                    .imageScale(.large)
                    .rotationEffect(.degrees(180))
                Text("Cheat")
            }
        })
    }
    
    var cards: some View {
        AspectVGrid(shapeSetGame.choices, aspectRatio: 3/4) { card in
            if isDealt(card: card) {
                CardView(card)
                    .padding(5)
                    .overlay(FlyingNumber(number: scoreChange(by: card)))
                    .zIndex(scoreChange(by: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        choose(card: card)
                    }
                    .onDisappear {
                        dealt.remove(card.id)
                    }
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .onAppear {
            var delay: TimeInterval = 0
            withAnimation(.easeInOut(duration: 1).delay(delay)) {
                for card in shapeSetGame.choices {
                    deal(card: card)
                    delay += 0.2
                }
            }
        }
    }
    
    @State var dealt: Set<Card.ID> = Set()
    
    func isDealt(card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    func deal(card: Card) -> Void {
        withAnimation() {
            shapeSetGame.faceUp(card: card)            
        }
        dealt.insert(card.id)
    }
    
    
    func choose(card: Card ) -> Void {
        var popedCards: Array<Card.ID> = []
        withAnimation() {
            let scoreBeforeChoosing = shapeSetGame.score
            popedCards = shapeSetGame.choose(card)
            let scoreChange = shapeSetGame.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange , causeBy: card.id)
        }
        dealCards()
        
        func dealCards() -> Void {
            if popedCards.count != 0 {
                var delay : TimeInterval = 0
                for id in popedCards {
                    if let popedCard = shapeSetGame.choices.first(where: {$0.id == id}) {
                        withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                            deal(card: popedCard)
                        }
                        delay += 0.2
                    }
                }
            }
        }
    }
    
    @State private var lastScoreChange: (amount: Int, causeBy: Card.ID) = (0, causeBy: "")
    
    func scoreChange(by card: Card ) -> Int  {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}

#Preview {
    ShapeSetGameView()
}
