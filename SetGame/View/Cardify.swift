//
//  Cardify.swift
//  SetGame
//
//  Created by 나동건 on 8/6/24.
//

import SwiftUI

struct Cardify: ViewModifier {
    let color: Color
    let isCheatSet: Bool
    let isSelected: Bool
    let isFaceUp: Bool
    
    private struct Constants {
        struct Card {
            static let cornerRadius = 25.0
            static let maxSize: CGFloat = 200
            static let minSize: CGFloat = 10
            static let minMaxRatio = minSize / maxSize
            static let aspectRatio: CGFloat = 2/3
            static let padding: CGFloat = 5
            struct Background {
                static let base: Color = .white
                static let cheat: Color = .yellow
                static let opacity: CGFloat = 0.3
            }
            struct Stroke {
                static let base: CGFloat = 2
                static let slected: CGFloat = 4
            }
        }
    }
    
    func body(
        content: Content
    ) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
            base
                .stroke(
                    isFaceUp ? color : .gray,
                    lineWidth: Constants.Card.Stroke.base
                )
                .shadow(
                    color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.01),
                    radius: 0, x: 0.001, y: 0.001
                )
            
            base 
                .fill(
                    isCheatSet ? Constants.Card.Background.cheat : Constants.Card.Background.base
                )
                .opacity(Constants.Card.Background.opacity)
            
            base
                .stroke(.black, lineWidth: Constants.Card.Stroke.slected)
                .opacity(isSelected ? 1 : 0)
            
            content
                .padding()
            
            base
                .fill(.indigo)
                .opacity(isFaceUp ? 0 : 1)
        }
        .font(.system(size: Constants.Card.maxSize))
        .minimumScaleFactor(Constants.Card.minMaxRatio)
        .aspectRatio(Constants.Card.aspectRatio, contentMode: .fit)
        .foregroundColor(color)
        .padding(Constants.Card.padding)
    }
    
}

extension View {
    func cardify(
        color: Color,
        isCheatSet: Bool,
        isSelected: Bool,
        isFaceUp : Bool
    ) -> some View {
        modifier(
            Cardify(
                color: color,
                isCheatSet: isCheatSet,
                isSelected: isSelected,
                isFaceUp: isFaceUp
            )
        )
    }
}

