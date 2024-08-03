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
            Text("Set Game")
                .font(.largeTitle)
            
            cards
            
            Button("Draw") {
                shapeSetGame.draw()
            }
            
            Button("cheat") {
                shapeSetGame.cheat()
            }
            
        }
        .padding()
        
    }
    
    var cards: some View {
        Group {
            ScrollView {
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
                            .animation(.default, value: shapeSetGame.choices)
                    }
                }
            }
            Spacer()
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
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
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
        .aspectRatio(2/3, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
        .foregroundColor(interpretCardColor(card.color))
        .padding(4)
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
        case CardTheme.contents.a:
            circle
        case CardTheme.contents.b:
            triangle
        case CardTheme.contents.c:
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
