//
//  ShapeSetGameView.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import SwiftUI

struct ShapeSetGameView: View {
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
            Text("Set Game")
                .font(.largeTitle)
            Text("Score: \(shapeSetGame.score)")
                .font(.title3)
        }
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
        Group {
            AspectVGrid(shapeSetGame.choices, aspectRatio: 3/4) { card in
                CardView(card)
                    .onTapGesture {
                        withAnimation {
                            shapeSetGame.choose(card)
                        }
                    }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ShapeSetGameView()
}
