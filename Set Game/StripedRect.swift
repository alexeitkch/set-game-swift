//
//  StripedRect.swift
//  Set Game
//
//  Created by Aleksey on 3/15/23.
//

import SwiftUI

struct StripedRect: Shape {
   
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: rect.minX, y: rect.minY)
        let  spacing: CGFloat = rect.width/10
        var path = Path()
        path.move(to: start)
        while path.currentPoint!.x < rect.maxX {
            path.addLine(to: CGPoint(x: path.currentPoint!.x, y: rect.maxY))
            path.move(to: CGPoint(x: path.currentPoint!.x + spacing, y: rect.minY))
        }
        return path
    }
}
