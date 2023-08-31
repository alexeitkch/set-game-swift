//
//  Button style.swift
//  Set Game
//
//  Created by Aleksey on 3/24/23.
//

import SwiftUI

//Button styles
struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct CapsuleButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .overlay(Capsule().strokeBorder(Color.yellow, lineWidth: 3.0)) //обводка кнопки
            .foregroundColor(Color.yellow) //цвет шрифта в кнопке
            .scaleEffect(configuration.isPressed ? 1.2 : 1) //эффкт увеличения при нажатии
            .opacity(configuration.isPressed ? 0.5 : 1.0) //исчезновение при нажатии
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed) //длит. анимации
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .foregroundColor(.white)
            .background(Color(red: 0.2, green: 0.4, blue: 0.2))
            .clipShape(RoundedRectangle(cornerRadius: 15.0))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ColorButton: ButtonStyle {
    var sets: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .overlay(Capsule().strokeBorder(sets ? Color.red : Color.white, lineWidth: 3.0)) //обводка кнопки
            .foregroundColor(sets ? Color.red : Color.white) //цвет шрифта в кнопке
            .scaleEffect(configuration.isPressed ? 1.2 : 1) //эффкт увеличения при нажатии
            .opacity(configuration.isPressed ? 0.5 : 1.0) //исчезновение при нажатии
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed) //длит. анимации
    }
}
