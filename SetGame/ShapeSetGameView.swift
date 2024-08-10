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
    
    @Namespace private var dealingNameSpace
    
    private let cardWidth: CGFloat = 50
    private let dealDelay: TimeInterval = 0.1
    
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
            HStack(alignment: .center) {
                deck
                Spacer()
                score
                Spacer()
                dummy
            }
        }
    }
    
    var dummy: some View {
        ZStack {
            var degree: Double  = 0
            var rotation: Double {
                get {
                    if degree > 5 {
                        degree = -10
                    } else {
                        degree += 2
                    }
                    return degree
                }
                set { degree = newValue }
            }
            
            
            ForEach(shapeSetGame.dummy) { card in 
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .rotationEffect(.degrees(rotation))
                    
            }
        }
        .frame(width: cardWidth, height: cardWidth / (2/3))
    }
    
    var score: some View  {
        Text("Score: \(shapeSetGame.score)")
            .font(.title3)
            .animation(nil)
    }
    
    var buttons: some View {
        HStack(alignment: .bottom, spacing: 40) {
            shuffle
            cheatButton
        }
        .padding()
    }
    
    var deck: some View {
        var deckView: some View {
            ZStack {
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
                        .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                        .offset(
                            x: cardOffset,
                            y: cardOffset
                        )
                        .zIndex(-cardOffset)
                        .shadow(radius: 0.1, x: 0.01, y: 0.01)
                        .frame(width: cardWidth, height: cardWidth / (2/3))
                }
            }
        }
        
        return deckView
            .onTapGesture {
                draw()
            }
        
        func draw() -> Void {
            var drawCardId: Array<Card.ID> = []
            withAnimation {
                drawCardId = shapeSetGame.draw()
            }
            var delay: TimeInterval = 0
            for id in drawCardId {
                withAnimation(.easeInOut(duration: 1).delay(delay)) {
                    if let drawCard = shapeSetGame.hand.first(where: { $0.id == id } ) {
                        deal(card: drawCard)
                        delay += dealDelay
                    }
                }
            }
        }
    }
    
    var shuffle: some View {
        return Button(
            action: { shuffle() },
            label: {
                VStack(spacing: 5) {
                    Image(systemName: "shuffle")
                        .font(.title)
                        .imageScale(.large)
                    Text("Shuffle")
                }
            })
        
        func shuffle() -> Void {
            withAnimation(.easeInOut) {
                dealt = Set()
                shapeSetGame.shuffle()
            }
            shapeSetGame.firstDeal()
            var delay: TimeInterval = 0
            for card in shapeSetGame.hand {
                withAnimation(.easeInOut(duration: 1).delay(delay)) {
                    deal(card: card)
                    delay += dealDelay
                }
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
        AspectVGrid(shapeSetGame.hand, aspectRatio: 3/4) { card in
            if isDealt(card: card) {
                CardView(card)
                    .zIndex(scoreChange(by: card) != 0 ? 1 : 0)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(/*@START_MENU_TOKEN@*/.identity/*@END_MENU_TOKEN@*/)
                    .padding(5)
                    .overlay(FlyingNumber(number: scoreChange(by: card)))
                    .onTapGesture {
                        choose(card: card)
                    }
                    .onAppear {
                        shapeSetGame.faceUp(card: card)
                    }
                    .onDisappear {
                        dealt.remove(card.id)
                        withAnimation {
                            shapeSetGame.faceDown(card: card)
                        }
                    }
            } else {
                Color.clear
            }
        }
        .onAppear {
            withAnimation {
                shapeSetGame.firstDeal()
            }
            var delay: TimeInterval = 0
            for card in shapeSetGame.hand {
                withAnimation(.easeInOut(duration: 1).delay(delay)) {
                    deal(card: card)
                }
                delay += dealDelay
            }
        }
    }
    
    @State var dealt: Set<Card.ID> = Set()
    
    func isDealt(card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    func deal(card: Card) -> Void {
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
        replaceCards()
        
        func replaceCards() -> Void {
            if popedCards.count != 0 {
                var delay : TimeInterval = 0
                for id in popedCards {
                    if let popedCard = shapeSetGame.hand.first(where: {$0.id == id}) {
                        withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                            deal(card: popedCard)
                        }
                        delay += dealDelay
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
