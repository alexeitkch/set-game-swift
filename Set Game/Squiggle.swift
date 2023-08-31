//
//  Squiggle.swift
//  Set Game
//
//  Created by Aleksey on 3/14/23.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        //print("rect hight: \(rect.height) rect.width: \(rect.width)")
        //rect.hight = 57.0 rect.width = 114.0
        var path = Path()
        path.move(to: CGPoint(x: rect.width / 1.03, y: rect.height / 6.41))         //1
        path.addCurve(to: CGPoint(x: rect.width / 1.75, y: rect.height / 1.09),     //2
                control1: CGPoint(x: rect.width / 0.93, y: rect.height / 1.6),      //3
                control2: CGPoint(x: rect.width / 1.2,  y: rect.height / 0.96))     //4
        path.addCurve(to: CGPoint(x: rect.width / 4.54, y: rect.height / 1.12),     //5
                control1: CGPoint(x: rect.width / 2.13, y: rect.height / 1.15),     //6
                control2: CGPoint(x: rect.width / 2.73, y: rect.height / 1.46))     //7
        path.addCurve(to: CGPoint(x: rect.width / 190,  y: rect.height / 1.55),     //8
                control1: CGPoint(x: rect.width / 20.35, y: rect.height / 0.89),    //9
                control2: CGPoint(x: rect.width / 95.0,  y: rect.height / 0.99))    //10
        path.addCurve(to: CGPoint(x: rect.width / 3.25, y: rect.height / 10.17),    //11
                control1: CGPoint(x: rect.width / 1140, y: rect.height / 3.41),     //12
                control2: CGPoint(x: rect.width / 7.04, y: rect.height / 17.27))    //13
        path.addCurve(to: CGPoint(x: rect.width / 1.21, y: rect.height / 7.31),     //14
                control1: CGPoint(x: rect.width / 1.88, y: rect.height / 6.4),      //15
                control2: CGPoint(x: rect.width / 1.78, y: rect.height / 2.09))     //16
        path.addCurve(to: CGPoint(x: rect.width / 1.03, y: rect.height / 6.4),      //17
                control1: CGPoint(x: rect.width / 1.12, y: rect.height / 51.82),    //18
                control2: CGPoint(x: rect.width / 1.06, y: rect.height / 57.0))     //19
        return path
    }
}

/*
 path.move(to: CGPoint(x: 110.6,    y: 8.9))    //1
path.addCurve(to: CGPoint(x: 65.1,  y: 52.2),   //2
     control1: CGPoint(x: 122.3,    y: 35.6),   //3
     control2: CGPoint(x: 94.5,     y: 59.4))   //4
path.addCurve(to: CGPoint(x: 25.1,  y: 51.1),   //5
     control1: CGPoint(x: 53.4,     y: 49.4),   //6
     control2: CGPoint(x: 41.7,     y: 38.9))   //7
path.addCurve(to: CGPoint(x: 0.6,   y: 36.7),   //8
     control1: CGPoint(x: 5.6,      y: 63.9),   //9
     control2: CGPoint(x: 1.2,      y: 57.2))   //10
path.addCurve(to: CGPoint(x: 35.1,  y: 5.6),    //11
     control1: CGPoint(x: 0.1,      y: 16.7),   //12
     control2: CGPoint(x: 16.2,     y: 3.3))    //13
path.addCurve(to: CGPoint(x: 93.9,  y: 7.8),    //14
     control1: CGPoint(x: 60.6,     y: 8.9),    //15
     control2: CGPoint(x: 63.9,     y: 27.2))   //16
path.addCurve(to: CGPoint(x: 110.6, y: 8.9),    //17
     control1: CGPoint(x: 101.2,    y: 1.1),    //18
     control2: CGPoint(x: 107.3,    y: 1.0))    //19
 */

