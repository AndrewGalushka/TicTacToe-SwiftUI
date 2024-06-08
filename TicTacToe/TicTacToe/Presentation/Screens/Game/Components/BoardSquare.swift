//
//  BoardSquare.swift
//  TicTacToe
//
//  Created by Andrew Halushka on 14.03.2023.
//

import SwiftUI
import Core

struct BoardSquare<S: Shape>: View {
    @ViewBuilder var content: S
    var lineWidth: CGFloat = 8
    var onTap: Command = .nop
    
    @State private var animatePath: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.gray.opacity(0.2))
            
            content
                .trim(from: 0, to: animatePath ? 1.0 : 0)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .padding(10)
        }
        .onTapGesture {
            onTap.perform()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
                animatePath = true
            }
        }
    }
}

#Preview {
    BoardSquare(content: { XMarkShape() }, onTap: .nop)
        .frame(width: 40, height: 40)
}
