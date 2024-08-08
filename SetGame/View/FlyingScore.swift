//
//  FlyingScore.swift
//  SetGame
//
//  Created by 나동건 on 8/8/24.
//

import SwiftUI

struct FlyingNumber : View {
    var number : Int
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        if number != 0 {
            Text(
                number,
                format: .number.sign(
                    strategy: .always(includingZero: false)
                )
            )
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .fontWeight(.heavy)
            .shadow(color: .gray, radius: 0.5, x: 1, y: 1)
            .foregroundColor(number > 0 ? .green: .red)
            .opacity(offset != 0 ? 0 : 1)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.easeIn(duration: 1)) {
                    offset = number > 0 ? -200 : 200
                }
            }
            .onDisappear {
                offset = 0
            }
        }
        
    }
}

#Preview {
    FlyingNumber (number: 1)
}
