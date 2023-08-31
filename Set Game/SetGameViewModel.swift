//
//  SetGameViewModel.swift
//  Set Game
//
//  Created by Aleksey on 3/14/23.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias  Card = SetGameModel.Card

    static func createSetGame() -> SetGameModel {
        SetGameModel()
    }
    
    @Published private var model = createSetGame()
    
    var cards: [SetGameModel.Card] {
        model.cards
    }
    
    //карты оставшиеся в колоде
    var cardsDeck: [SetGameModel.Card] {
        model.cardsDeck
    }
    
    //размер выигр. штраф. очков
    var bonus: Int {
        model.bonus
    }
    
    //вычисляет общий счет в игре
    var score: Int {
        model.score
    }
    
    //определяет цвет выделения карт при выборе 3
    var setMode: Triple {
        model.setMode
    }
    
    //количество сетов в сданных картах
    var sets: Int {
        return model.setsCount
    }
    
    var setIs: Bool {
        model.setIs
    }
    
    //условие конец игры
    var gameOver: Bool {
        model.gameOver
    }
    
    //функция интерпретации содержимого карты
    static func cardConent(_ card:Card) -> CardContent {
        let content: CardContent = CardContent(
            color: card.content.color,
            quantity: card.content.quantity,
            pattern: card.content.pattern,
            shape: card.content.shape)
        return content
    }
    
    //структура для представления содержимого карты
    struct CardContent: View, Equatable {
        var color: Int
        var quantity: Int
        var pattern: Int
        var shape: Int
        
        var body: some View {
            ZStack {
                if quantity == 0 {
                    patternSelect(pattern: pattern)
                } else if quantity == 1 {
                    VStack {
                        patternSelect(pattern: pattern)
                        patternSelect(pattern: pattern)
                    }
                } else {
                    VStack {
                        patternSelect(pattern: pattern)
                        patternSelect(pattern: pattern)
                        patternSelect(pattern: pattern)
                    }
                }
            }
        }
        
        @ViewBuilder
        func patternSelect(pattern: Int) -> some View {
            VStack {
                if pattern == 0 {
                    strokedSymbol(shape: shape)
                } else if pattern == 1 {
                    shadedSymbol(shape: shape)
                } else {
                    filledSymbol(shape: shape)
                }
            }.aspectRatio(2/1, contentMode: .fit)
        }
        
        @ViewBuilder
        func strokedSymbol(shape: Int) -> some View {
            if shape == 0 {
                Diamond().stroke(lineWidth: 2.0)
            } else if shape == 1 {
                Oval().stroke(lineWidth: 2.0)
            } else {
                Squiggle().stroke(lineWidth: 2.0)
            }
        }
        
        @ViewBuilder
        func shadedSymbol(shape: Int) -> some View {
            if shape == 0 {
                ZStack {//striped
                    //Diamond().opacity(0.2)
                    StripedRect().stroke().clipShape(Diamond())
                    Diamond().stroke(lineWidth: 2.0)
                }
            } else if shape == 1 {
                ZStack {
                    //Oval().opacity(0.2)
                    StripedRect().stroke().clipShape(Oval())
                    Oval().stroke(lineWidth: 2.0)
                }
            } else {
                ZStack {
                    //Squiggle().opacity(0.2)
                    StripedRect().stroke().clipShape(Squiggle())
                    Squiggle().stroke(lineWidth: 2.0)
                }
            }
        }
        
        @ViewBuilder
        func filledSymbol(shape: Int) -> some View {
            if shape == 0 {
                Diamond().fill()
            } else if shape == 1 {
                Oval().fill()
            } else {
                Squiggle().fill()
            }
        }
    }
    
    
    //MARK: Intent(s)
    //выбор карты на столе
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    //тап по игровому столу
    func tapOnBackground() {
        model.tapOnBackground()
    }
    
    //раздача дополнительных 3 карт
    func deal3MoreCards() {
        model.deal3MoreCards()
    }
    
    //цвет фигур на карте
    func cardColor(_ card: Card) -> Color {
        var outColor: Color
        switch card.content.color {
            case 0: outColor = .red
            case 1: outColor = .purple
            case 2: outColor = .green
        default:
            outColor = .gray //не имеет места
        }
        return outColor
    }
    
    //создание новой игры
    func restart() {
        model = SetGameViewModel.createSetGame()
    }
}
