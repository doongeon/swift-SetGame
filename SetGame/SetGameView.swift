//
//  ContentView.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var shapeSetGame = ShapeSetGame()
    
    var body: some View {
        LazyVGrid(
            columns: [GridItem(
                .adaptive(minimum: 75),spacing: 0
            )],
            spacing: 0
        ) {
            ForEach(shapeSetGame.choices) { card in
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        shapeSetGame.choose(card)
                    }
            }
        }.padding()
    }
}

struct CardView: View  {
    let card: SetGame<String>.Card
    
    init(card: SetGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .fill(.white)
                .stroke(.red)
            VStack(spacing: 5) {
                Text(card.content)
                Text(card.color)
                Text(card.shade)
                Text("\(card.count)")
            }.padding(4)
            .font(.system(size: 2000))
            .minimumScaleFactor(0.001)
            .aspectRatio(1/2, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    ContentView()
}
