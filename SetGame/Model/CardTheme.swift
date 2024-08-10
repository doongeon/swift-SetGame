//
//  Theme.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import Foundation

struct CardTheme {
    enum colors: CaseIterable {
        case red
        case green
        case blue
    }
    enum contents: CaseIterable {
        case triangle
        case diamond
        case circle
    }
    enum numOfShape: CaseIterable {
        case one
        case two
        case three
    }
    enum shades: CaseIterable {
        case solid
        case blur
        case blank
    }
    
    func deckGenerator() -> Array<SetGame.Card> {
        var result:Array<SetGame.Card> = []
        for color in colors.allCases {
            for content in contents.allCases {
                for shade in shades.allCases {
                    for num in numOfShape.allCases {
                        result.append(
                            SetGame.Card(
                                color: color,
                                numOfShape: num,
                                content: content,
                                shade: shade,
                                isFaceUp: false,
                                id: "\(shade) \(color) \(content) * \(num )"
                            )
                        )
                    }
                }
            }
        }
        return result.shuffled()
    }
    
}
