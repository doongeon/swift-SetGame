//
//  CardView.swift
//  SetGame
//
//  Created by 나동건 on 8/6/24.
//

import SwiftUI

struct ShapeCardView: View  {
    let card: SetGame.Card 
    
    init(_ card: SetGame.Card) {
        self.card = card
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
    
    var body: some View {
        Pie(endAngle: .degrees(270), clockwise: true )
            .fill(.gray)
            .opacity(0.3)
            .overlay(cardContentView)
            .cardify(
                color: interpretColor(card.color),
                isCheatSet: card.isCheatSet,
                isSelected: card.isSelected
            )
    }
    
    var cardContentView: some View {
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
            shapeView(of: Triangle())
        case CardTheme.contents.diamond:
            shapeView(of: Diamond())
        case CardTheme.contents.circle:
            shapeView(of: Circle())
        }
    }
    
    func shapeView(of shape: some Shape) -> some View {
        ZStack {
            shape.fill(card.shade == CardTheme.shades.blank ? Constants.Card.Background.base : interpretColor(card.color))
            shape.stroke(lineWidth: Constants.Shape.stroke)
        }
        .opacity(card.shade == CardTheme.shades.blur ? Constants.Shape.blurOpacity : 1)
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
            ShapeCardView(
                SetGame.Card(
                    color: CardTheme.colors.blue,
                    numOfShape: CardTheme.numOfShape.one,
                    content: CardTheme.contents.triangle,
                    shade: CardTheme.shades.blank,
                    id: "1"
                )
            )
            ShapeCardView(
                SetGame.Card(
                    color: CardTheme.colors.blue,
                    numOfShape: CardTheme.numOfShape.two,
                    content: CardTheme.contents.triangle,
                    shade: CardTheme.shades.blank,
                    id: "2"
                )
            )
        }
        HStack() {
            ShapeCardView(
                SetGame.Card(
                    color: CardTheme.colors.red,
                    numOfShape: CardTheme.numOfShape.one,
                    content: CardTheme.contents.diamond,
                    shade: CardTheme.shades.blank,
                    id: "3"
                )
            )
            ShapeCardView(
                SetGame.Card(
                    color: CardTheme.colors.red,
                    numOfShape: CardTheme.numOfShape.two,
                    content: CardTheme.contents.circle,
                    shade: CardTheme.shades.blank,
                    id: "4"
                )
            )
            ShapeCardView(
                SetGame.Card(
                    color: CardTheme.colors.red,
                    numOfShape: CardTheme.numOfShape.two,
                    content: CardTheme.contents.circle,
                    shade: CardTheme.shades.blank,
                    id: "4"
                )
            )
        }
    }
    .padding()
}
