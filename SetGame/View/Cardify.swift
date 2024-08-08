//
//  Cardify.swift
//  SetGame
//
//  Created by 나동건 on 8/6/24.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    let isCheatSet: Bool
    let isSelected: Bool
    var isFaceUp: Bool {
        rotation < 90 || rotation > 270
    }
    var rotation: Double
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(isFaceUp: Bool, isCheatSet: Bool, isSelected: Bool) {
        self.isCheatSet = isCheatSet
        self.isSelected = isSelected
        if isFaceUp {
            rotation  = isSelected ? 0 : 360
        } else {
            rotation = 180
        }
    }
    
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
                .stroke(lineWidth: 3)
            
            base 
                .fill(Constants.Card.Background.base)
            
            base
                .fill(Constants.Card.Background.cheat)
                .opacity(isCheatSet ? 0.3 : 0)
            
            base
                .stroke(
                    .orange,
                    lineWidth: Constants.Card.Stroke.slected
                )
                .opacity(isSelected ? 1 : 0)
            
            content
                .padding()
            
            base
                .fill(.orange)
                .opacity(isFaceUp ? 0 : 1)
        }
        .font(.system(size: Constants.Card.maxSize))
        .minimumScaleFactor(Constants.Card.minMaxRatio)
        .aspectRatio(Constants.Card.aspectRatio, contentMode: .fit)
        .rotation3DEffect(
            .degrees(rotation),axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
        )
    }
    
}

extension View {
    func cardify(
        isFaceUp : Bool,
        isSelected: Bool,
        isCheatSet: Bool
    ) -> some View {
        modifier(
            Cardify(
                isFaceUp: isFaceUp,
                isCheatSet: isCheatSet,
                isSelected: isSelected
            )
        )
    }
}

