//
//  Theme.swift
//  SetGame
//
//  Created by 나동건 on 7/31/24.
//

import Foundation

struct CardTheme<CardContent> {
    let colors: Array<String>
    let contents: Array<CardContent>
    let shades = ["solid", "blur", "blank"]
    let nums = [1, 2, 3]
    
    init(colors: Array<String>, contents: Array<CardContent>) {
        self.colors = colors
        self.contents = contents
    }
    
    func deckGenerator() -> Array<SetGame<CardContent>.Card> {
        var result:Array<SetGame<CardContent>.Card> = []
        
        for color in colors {
            for content in contents {
                for shade in shades {
                    for num in nums {
                        result.append(
                            SetGame<CardContent>.Card(
                                color: color,
                                count: num,
                                content: content,
                                shade: shade,
                                id: "\(color) & \(num) & \(content) & \(shade)"
                            )
                        )
                    }
                }
            }
        }
        
        return result
    }
}
