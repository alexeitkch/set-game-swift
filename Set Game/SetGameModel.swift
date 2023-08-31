//
//  SetGameModel.swift
//  Set Game
//
//  Created by Aleksey on 4/1/23.
//

import Foundation

enum Triple: CaseIterable {
    case a
    case b
    case c
}

struct SetGameModel {
    private (set) var cardsDeck = [Card]()
    private (set) var cards = [Card]()
    private let deckCount = 81
    private (set) var score: Int
    private (set) var profit: Int
    private (set) var fine: Int
    private (set) var bonus: Int
    private (set) var setMode: Triple //состояние Common, Set, Not_Set
    private (set) var gameOver: Bool
    private (set) var setIs: Bool
    
    private var cardsDeckIsEmpty: Bool {
        return cardsDeck.isEmpty ? true : false
    }
    
    var setsCount: Int {
        setSearch(cards)
    }
    
    init() {
        score = 0
        setMode = .a    //Empty
        profit = 10     //баллы за сет
        fine = -5       //штрафные баллы за сдачу 3 доп.карт, если сет на поле есть
        bonus = 0
        setIs = false
        gameOver = false
        cardsDeck = createCardsDeck(count: 81)
        cards = []
        for index in 0..<12 { //сдача первых 12 карт
            cards.append(cardsDeck[index])
        }
        setIs = setsIs(cards) //проверка на сет
        cardsDeck = cardsDeck.suffix(cardsDeck.count - 12) //удаляем из колоды первые 12 карт
    }
    
    private func createCardsDeck(count: Int) -> [Card] {
        var arr: [Card] = []
        //создаем массив колоды карт
        var color = 0, quantity = 0, pattern = 0, shape = 0
        var deck: Int {
            if count > 81 {
                return 81
            } else {
                return count
            }
        }
        for index in 0..<deck { //создание колоды из 81 карты для сет
            arr.append(Card(
                    content: (color, quantity, pattern, shape),
                    id: index))
            if color < 2 {color += 1} else {color = 0
                if pattern < 2 {pattern += 1} else {pattern = 0
                    if quantity < 2 {quantity += 1} else {quantity = 0
                        if shape < 2 {shape += 1} else {shape = 0}
                    }
                }
            }
        }
        arr = arr.shuffled()
        return arr
    }
    
    private func setsIs(_ arr:[Card]) -> Bool {
        if setSearch(arr) > 0 {
            return true
        } else {
            return false
        }
    }
    
    //дополнительные 3 карты в игру
    mutating func deal3MoreCards() {
        //проверка на сет выполнялась при раздаче
        //print("deal3MoreCards_setsCount")
        if setsCount != 0 { //если на столе был сет штрафуем
            bonus = fine //бонусы равны штрафу
            score += fine //общий результат
        }
        //раздача 3 карт
        if cardsDeck.count >= 3 {
            for index in 0..<3 {
                cards.append(cardsDeck[index]) //копируем 3 карты из колоды
            }
            setIs = setsIs(cards)//2 проверка на сет
            cardsDeck = cardsDeck.suffix(cardsDeck.count - 3) //удаляем 3 карты из колоды
        }
    }

    //количество выбранных карт
    private var quantityOfSelectedCards: Int {
        let select = cards.filter({$0.isChoose})
        return select.count
    }
    
    //разрешение делать анализ 3 карт
    private var willCompare: Bool = true
    
    private mutating func willCompareMove() {
        let select = cards.filter({$0.isChoose})
        //print("setSearch_in_3_choosen_cards")
        if(setSearch(select) != 0) {
            setMode = .b //Set
            score += profit
            bonus = profit
            for i in 0..<3 {
                if let index = cards.index(matching: select[i]) {
                    cards[index].isMatched = true
                }
            }
        } else {setMode = .c} //Not_Set
        willCompare = false
    }
    
    private mutating func pastCompareMove() {
        //снимаем выделение со всех карт...
        for index in cards.indices {
            cards[index].isChoose = false
        }
        //если карт на поле больше 12 удаляем "совпавшие" или сдавать уже нечего...
        if cards.count > 12 || cardsDeckIsEmpty {
            if !cards.isEmpty {
                cards.removeAll(where: {$0.isMatched == true})
            }
        } else { //... иначе меняем их картами из колоды
            for index in cards.indices {
                //замена карт игры из колоды при получении Set
                if cards[index].isMatched {
                    if let cardDeck = cardsDeck.first {
                        cards[index] = cardDeck //замена карты на столе картой из колоды
                        cardsDeck.remove(at: 0) //карту которую выложили на стол удаляем из колоды
                    }
                }
            }
        }
        setIs = setsIs(cards) //3 проверка на сет
        gameOverCheck()
        willCompare = true //разрешаем сравнение
        setMode = .a //Common
        bonus = 0
    }
    
    //выбор карты
    mutating func choose(_ card: Card) {
        //процедура изменяет состояние карты на "выбрана"/"не выбрана"
        //при условии что карта "не совпавшая" и количество уже выбранных катр меньше трех, игра не закончена
        if let index = cards.index(matching: card),!cards[index].isMatched, quantityOfSelectedCards < 3, !gameOver {
            cards[index].isChoose.toggle()
            bonus = 0
        }
        //если карт 3 начинаем сравнение
        if quantityOfSelectedCards == 3 {
            if willCompare { //сравнение карт ...
                willCompareMove()
            } else { //... действия после сравнения
                pastCompareMove()
            }
        }
    }
    
    //при жесте тап по фону снимает выделение с карт и меняет карты если сет
    mutating func tapOnBackground() {
        pastCompareMove()
        //gameOverCheck()
    }
    
    //проверка на окончание игры
    private mutating func gameOverCheck() {
        if cardsDeckIsEmpty {
            if (setsCount == 0) || (cards.isEmpty) {
                gameOver = true //конец игры
            }
        }
    }
    
    //функция поиска сетов в массиве карт
    private func setSearch(_ arr:[Card]) -> Int {
        if arr.count >= 3 {
            let lim1 = arr.count - 1, lim2 = arr.count - 2, lim3 = arr.count - 3
            var cnt0 = 0, cnt1 = 2, cnt2 = 1
            var set = 0
            var select: Array<Card> = []
                //Nested function
                func isSet(_ arrSet: [Card]) -> Bool {
                    var s0 = 0, s1 = 0, s2 = 0, s3 = 0
                    for i in arrSet.indices {
                        s0 += arrSet[i].content.color
                        s1 += arrSet[i].content.shape
                        s2 += arrSet[i].content.quantity
                        s3 += arrSet[i].content.pattern
                    }
                    if((s0%3 + s1%3 + s2%3 + s3%3) == 0) {
                        return true
                    } else {
                        return false
                    }
                }
            for index2 in 0...lim3 {
                for index1 in cnt2...lim2 {
                    for index in cnt1...lim1 {
                        select = []
                        select.append(arr[index2])
                        select.append(arr[index1])
                        select.append(arr[index])
                        cnt0 += 1 //счетчик общего количества циклов сравнений
                        if isSet(select) {set += 1} //проверка на сет трех карт (для 12 карт 220 циклов)
                    }
                    if (cnt1 < lim1) {cnt1 += 1}
                }
                if (cnt2 < lim2) {cnt2 += 1}
                cnt1 = index2 + 3
            }
            print("compare circles = \(cnt0)") //циклы сравнения при 12 картах 220 циклов
            print("set count = \(set)") // количество сетов
            return set
        } else {
            return 0
        }
    }
    
    //структура карты
    struct Card: Identifiable {
        var isChoose = false
        var isMatched = false
        var content: (color: Int,shape: Int,quantity: Int,pattern: Int)
        var id: Int
    }
}

//поиск элементов в коллекциях
extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        return firstIndex(where: {$0.id == element.id})
    }
}
//удаление елементов из изменяемых коллекций
extension RangeReplaceableCollection where Element: Identifiable {
    mutating func remove(_ element: Element) {
        if let index = index(matching: element) {
            remove(at: index)
        }
    }
}


