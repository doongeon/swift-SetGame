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
                withAnimation() {
                    shapeSetGame.draw()
                }
            }, label: {
                VStack(spacing: 5) {
                    Image(systemName: "arrow.turn.up.forward.iphone")
                        .font(.title)
                        .imageScale(.large)
                    Text("Draw")
                }
            })
    }
    
    var newgameButton: some View {
        Button(action: {
            withAnimation {
                shapeSetGame.newGame()
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
            CardView(card)
                .padding(5)
                .overlay(FlyingNumber(number: scoreChange(by: card)))
                .zIndex(scoreChange(by: card) != 0 ? 1 : 0)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        choose(card: card)
                    }
                }
        }
    }
    
    func choose(card: Card ) -> Void {
        let scoreBeforeChoosing = shapeSetGame.score
        shapeSetGame.choose(card)
        let scoreChange = shapeSetGame.score - scoreBeforeChoosing
        lastScoreChange = (scoreChange , causeBy: card.id)
    }
    
    @State private var lastScoreChange = (0, causeBy: "")
    
    func scoreChange(by card: Card ) -> Int  {
        let (amount, id ) = lastScoreChange
        if card.id == id {
            print(amount)
//            print("card id: \(card.id)")
//            print("cased id: \(id)")
        } else {
            print(0)
        }
        
        return card.id == id ? amount : 0
    }
}

#Preview {
    ShapeSetGameView()
}
