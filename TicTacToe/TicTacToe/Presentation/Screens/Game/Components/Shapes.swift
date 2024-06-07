//
//  Shapes.swift
//  TicTacToe
//
//  Created by ira on 07.06.2024.
//

import SwiftUI

struct XMarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let minLength = min(rect.size.width, rect.size.height)
        let canvasSize = CGSize(width: minLength, height: minLength)
        let canvasRect = CGRect(origin: CGPoint(x: center.x - canvasSize.width / 2,
                                                y: center.y - canvasSize.height / 2),
                                size: canvasSize)
        let canvasOrigin = canvasRect.origin
        let lineThickness = canvasSize.width * 0.1
        
        let pointOffsetFromCorner = (lineThickness * sqrt(2)) / 2
        let pointOffsetFromCenter = pointOffsetFromCorner
        
        let topCenterPoint = CGPoint(x: center.x,
                                     y: center.y - pointOffsetFromCenter)
        let bottomCenterPoint = CGPoint(x: center.x,
                                        y: center.y + pointOffsetFromCenter)
        let leftCenterPoint = CGPoint(x: center.x - pointOffsetFromCenter,
                                      y: center.y)
        let rightCenterPoint = CGPoint(x: center.x + pointOffsetFromCenter,
                                       y: center.y)
        
        let topLeftPoint1 = CGPoint(x: canvasOrigin.x + pointOffsetFromCorner,
                                    y: canvasOrigin.y)
        let topLeftPoint2 = CGPoint(x: canvasOrigin.x,
                                    y: canvasOrigin.y + pointOffsetFromCorner)
        
        let bottomLeftPoint1 = CGPoint(x: canvasOrigin.x,
                                       y: canvasOrigin.y + canvasSize.height - pointOffsetFromCorner)
        let bottomLeftPoint2 = CGPoint(x: canvasOrigin.x + pointOffsetFromCorner,
                                       y: canvasOrigin.y + canvasSize.height)
        
        let bottomRightPoint1 = CGPoint(x: canvasOrigin.x + canvasSize.width - pointOffsetFromCorner,
                                        y: canvasOrigin.y + canvasSize.height)
        let bottomRightPoint2 = CGPoint(x: canvasOrigin.x + canvasSize.width,
                                        y: canvasOrigin.y + canvasSize.height - pointOffsetFromCorner)
        
        let topRightPoint1 = CGPoint(x: canvasOrigin.x + canvasSize.width,
                                     y: canvasOrigin.y + pointOffsetFromCorner)
        let topRightPoint2 = CGPoint(x: canvasOrigin.x + canvasSize.width - pointOffsetFromCorner,
                                     y: canvasOrigin.y)
        let path = CGMutablePath()
                
        path.move(to: topCenterPoint)
        path.addLine(to: topLeftPoint1)
        path.addLine(to: topLeftPoint2)
        path.addLine(to: leftCenterPoint)
        path.addLine(to: bottomLeftPoint1)
        path.addLine(to: bottomLeftPoint2)
        path.addLine(to: bottomCenterPoint)
        path.addLine(to: bottomRightPoint1)
        path.addLine(to: bottomRightPoint2)
        path.addLine(to: rightCenterPoint)
        path.addLine(to: topRightPoint1)
        path.addLine(to: topRightPoint2)
        
        path.closeSubpath()
        
        return Path(path)
    }
}

struct CrossShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        return path
    }
}
