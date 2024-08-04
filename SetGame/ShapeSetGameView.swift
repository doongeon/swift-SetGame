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
        Button(action: {shapeSetGame.draw()}, label: {
            VStack(spacing: 5) {
                Image(systemName: "arrow.turn.up.forward.iphone")
                    .font(.title)
                    .imageScale(.large)
                Text("Draw")
            }
        })
    }
    
    var newgameButton: some View {
        Button(action: {shapeSetGame.newGame()}, label: {
            VStack(spacing: 5) {
                Image(systemName: "gamecontroller")
                    .font(.title)
                    .imageScale(.large)
                Text("New Game")
            }
        })
    }
    
    var cheatButton: some View {
        Button(action: {shapeSetGame.cheat()}, label: {
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
        VStack {
            Group {
                AspectVGrid(shapeSetGame.choices, aspectRatio: 3/4) { card in
                    CardView(card: card)
                        .padding(10)
                        .onTapGesture {
                            shapeSetGame.choose(card)
                        }
                }
                
                Spacer()
            }
        }
    }
}

struct CardView: View  {
    let card: SetGame.Card
    
    init(card: SetGame.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(interpretCardColor(card.color), lineWidth: 2)
            
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .fill(card.isCheatSet ? .yellow : .white)
                .opacity(0.3)
            
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .stroke(.black, lineWidth: card.isSelected ? 4 : 0)
            
            cardContentView
                .padding()
        }
        .font(.system(size: 100))
        .minimumScaleFactor(0.001)
        .aspectRatio(2/3, contentMode: .fit)
        .foregroundColor(interpretCardColor(card.color))
    }
    
    var cardContentView: some View {
        VStack(spacing: 5) {
            switch(card.numOfShape) {
            case CardTheme.numOfShape.one:
                ForEach(0..<1, id: \.self) { _ in
                    shape
                }
            case CardTheme.numOfShape.two:
                ForEach(0..<2, id: \.self) { _ in
                    shape
                }
            case CardTheme.numOfShape.three:
                ForEach(0..<3, id: \.self) { _ in
                    shape
                }
            }
        }
    }
    
    @ViewBuilder
    var shape: some View {
        switch(card.content) {
        case CardTheme.contents.content_a:
            circle
        case CardTheme.contents.content_b:
            triangle
        case CardTheme.contents.content_c:
            diamond
        }
    }
    
    var square: some View {
        ZStack {
            let base = Rectangle()
            base.fill(card.shade == CardTheme.shades.blank ? .white : interpretCardColor(card.color))
            base.stroke(lineWidth: 2)
        }.opacity(card.shade == CardTheme.shades.blur ? 0.3 : 1)
            .aspectRatio(2/1, contentMode: .fit)
    }
    
    var diamond: some View {
        ZStack {
            let base = Diamond()
            base.fill(card.shade == CardTheme.shades.blank ? .white : interpretCardColor(card.color))
            base.stroke(lineWidth: 2)
        }.opacity(card.shade == CardTheme.shades.blur ? 0.3 : 1)
            .aspectRatio(2/1, contentMode: .fit)
    }
    
    var triangle: some View {
        ZStack {
            let base = Triangle()
            base.fill(card.shade == CardTheme.shades.blank ? .white : interpretCardColor(card.color))
            base.stroke(lineWidth: 2)
        }.opacity(card.shade == CardTheme.shades.blur ? 0.3 : 1)
            .aspectRatio(2/1, contentMode: .fit)
    }
    
    var circle: some View {
        ZStack {
            let base = Circle()
            base.fill(card.shade == CardTheme.shades.blank ? .white : interpretCardColor(card.color))
            base.stroke(lineWidth: 2)
        }.opacity(card.shade == CardTheme.shades.blur ? 0.3 : 1)
            .aspectRatio(2/1, contentMode: .fit)
    }
    
    func interpretCardColor(_ color: CardTheme.colors) -> Color {
        switch(color) {
        case CardTheme.colors.red:
            return .red
        case CardTheme.colors.green:
            return .green
        case CardTheme.colors.blue:
            return .blue
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()

        return path
    }
}

#Preview {
    ShapeSetGameView()
}
