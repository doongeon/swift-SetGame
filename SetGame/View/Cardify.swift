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
    let isSet: Bool 
    
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
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .stroke(color, lineWidth: Constants.Card.Stroke.base)
            
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .fill(
                    isCheatSet ? Constants.Card.Background.cheat : Constants.Card.Background.base
                )
                .opacity(Constants.Card.Background.opacity)
            
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .stroke(.black, lineWidth: Constants.Card.Stroke.slected)
                .opacity(isSelected ? 1 : 0)
            
            content
                .padding()
        }
        .font(.system(size: Constants.Card.maxSize))
        .minimumScaleFactor(Constants.Card.minMaxRatio)
        .aspectRatio(Constants.Card.aspectRatio, contentMode: .fit)
        .foregroundColor(color)
        .padding(Constants.Card.padding)
        .rotationEffect(.degrees(isSet ? 360 : 0))
        .animation(.easeInOut(duration: 1), value: isSet)
        .rotation3DEffect(
            isSelected ? .degrees(360) : .zero, axis: (0,1,0)
        )
    }
    
}

extension View {
    func cardify(
        color: Color,
        isCheatSet: Bool,
        isSelected: Bool,
        isSet: Bool 
    ) -> some View {
       modifier(
            Cardify(
                color: color,
                isCheatSet: isCheatSet,
                isSelected: isSelected,
                isSet: isSet
            )
        )
    }
}

