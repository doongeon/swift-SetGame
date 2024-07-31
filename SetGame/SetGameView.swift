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
        VStack {
            Text("Set Game")
                .font(.largeTitle)
            cards
            Button("Draw") {
                shapeSetGame.draw()
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
                    }
                }
            }
            Spacer()
        }
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
                .stroke(interpretCardColor(card.color))
            
            VStack(spacing: 5) {
                ForEach(0..<card.count) { _ in
                    shape
                }
            }
            .padding()
        }
        .font(.system(size: 100))
        .minimumScaleFactor(0.001)
        .aspectRatio(2/3, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
        .foregroundColor(interpretCardColor(card.color))
        .padding(4)
    }
    
    func interpretCardColor(_ color: String) -> Color {
        switch(color) {
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        default:
            return .red
        }
    }
    
    @ViewBuilder
    var shape: some View {
        if(card.content == "circle") {
            circle
        } else if(card.content == "triangle") {
            triangle
        } else {
            square
        }
    }
    
    var square: some View {
        ZStack {
            let base = Rectangle()
            base.fill(card.shade == "blank" ? .white : interpretCardColor(card.color))
            base.stroke(lineWidth: 2)
        }.opacity(card.shade == "blur" ? 0.3 : 1)
            .aspectRatio(2/1, contentMode: .fit)
    }
    
    var triangle: some View {
        ZStack {
            let base = Triangle()
            base.fill(card.shade == "blank" ? .white : interpretCardColor(card.color))
            base.stroke(lineWidth: 2)
        }.opacity(card.shade == "blur" ? 0.3 : 1)
            .aspectRatio(2/1, contentMode: .fit)
    }
    
    var circle: some View {
        ZStack {
            let base = Circle()
            base.fill(card.shade == "blank" ? .white : interpretCardColor(card.color))
            base.stroke(lineWidth: 2)
        }.opacity(card.shade == "blur" ? 0.3 : 1)
            .aspectRatio(2/1, contentMode: .fit)
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

#Preview {
    ContentView()
}
