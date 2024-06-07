//
//  BoardSquare.swift
//  TicTacToe
//
//  Created by Andrew Halushka on 14.03.2023.
//

import SwiftUI
import Core

struct BoardSquare<Content: View>: View {
    @ViewBuilder var content: Content
    var onTap: Command = .nop
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.gray.opacity(0.2))
            
            content.padding(10)
        }
        .onTapGesture {
            onTap.perform()
        }
    }
}

#Preview {
    BoardSquare(content: { XMarkShape() }, onTap: .nop)
        .frame(width: 40, height: 40)
}
