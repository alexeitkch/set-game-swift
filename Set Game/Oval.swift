//
//  Oval.swift
//  Set Game
//
//  Created by Aleksey on 3/14/23.
//

import Foundation

import SwiftUI

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.width / 6, y: rect.midY),
                    radius: rect.width / 6,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        path.addArc(center: CGPoint(x: rect.width - rect.width / 6, y: rect.midY),
                    radius: rect.width / 6,
                    startAngle: Angle(degrees: 270),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.width / 6, y: rect.height / 1.2))
        return path
    }
}
