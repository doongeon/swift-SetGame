//
//  CardView.swift
//  SetGame
//
//  Created by 나동건 on 8/6/24.
//

import SwiftUI

struct CardView: View  {
    let card: SetGame.Card
    
    init(_ card: SetGame.Card) {
        self.card = card
    }
    
    var body: some View {
        cardContent
            .cardify(
                isFaceUp : card.isFaceUp,
                isSelected: card.isSelected,
                isCheatSet: card.isCheatSet
            )
            .foregroundColor(interpretColor(card.color))
            .rotationEffect(card.isSet ? .degrees(360) : .zero)
            .animation(.easeInOut(duration: 1), value: card.isSet)
    }
    
    var cardContent: some View {
        VStack(spacing: Constants.shapeGap) {
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
        case CardTheme.contents.triangle:
            applyShade(on : Triangle())
        case CardTheme.contents.diamond:
            applyShade(on : Diamond())
        case CardTheme.contents.circle:
            applyShade(on: Circle())
        }
    }
    
    func applyShade(on shape: some Shape) -> some View {
        ZStack {
            shape
                .fill()
                .opacity(
                    card.shade == CardTheme.shades.blur ?
                    Constants.Shape.blurOpacity : 1
                )
                .opacity(
                    card.shade == CardTheme.shades.blank ?
                    0 : 1
                )
            shape.stroke(lineWidth: Constants.Shape.stroke)
        }
        .aspectRatio(Constants.Shape.aspectRatio, contentMode: .fit)
    }
    
    func interpretColor(_ color: CardTheme.colors) -> Color {
        switch(color) {
        case CardTheme.colors.red:
            return .red
        case CardTheme.colors.green:
            return .green
        case CardTheme.colors.blue:
            return .blue
        }
    }
    
    private struct Constants {
        static let shapeGap: CGFloat = 5
        struct Card {
            struct Background {
                static let base: Color = .white
            }
        }
        struct Shape {
            static let aspectRatio: CGFloat = 2/1
            static let stroke: CGFloat = 2
            static let blurOpacity: CGFloat = 0.3
        }
    }
    
}

struct Pie: Shape {
    let startAngle: Angle = .degrees(0) - .degrees(90)
    let endAngle: Angle
    let clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius: CGFloat = min(rect.width, rect.height) / 2
        let endAngle: Angle = endAngle - .degrees(90)
        
        var path = Path()
        
        path.move(to: center)
        path.addLine(
            to: CGPoint(
                x: center.x,
                y: center.y + radius * sin(startAngle.radians)
            )
        )
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        path.addLine(to: center)
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
    return VStack() {
        HStack() {
            CardView(
                SetGame.Card(
                    color: CardTheme.colors.green,
                    numOfShape: CardTheme.numOfShape.one,
                    content: CardTheme.contents.triangle,
                    shade: CardTheme.shades.blank,
                    isFaceUp: true ,
                    id: "1"
                )
            )
            CardView(
                SetGame.Card(
                    color: CardTheme.colors.blue,
                    numOfShape: CardTheme.numOfShape.two,
                    content: CardTheme.contents.triangle,
                    shade: CardTheme.shades.blank,
                    isFaceUp: true ,
                    id: "2"
                )
            )
        }
    }
    .padding()
}
