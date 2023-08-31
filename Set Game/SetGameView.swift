//
//  SetGameView.swift
//  Set Game
//
//  Created by Aleksey on 3/14/23.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    @Namespace private var namespace
    @State private var dealt = Set<Int>() //набор куда помещаются сданные карты
    @State private var score = 0 //по значению переменной показываем счет в игре
    @State private var block = false //блокировка раздачи доп. 3 карт до конца анимации
    @State private var shouldDelay = false
    @State private var hintView = false
    //@State private var hightGrid: CGFloat = 0.0
    
    //=====Общий вид игры=====
    var body: some View {
        VStack {
            ZStack {
                gameBoard
                VStack {
                    topPanel
                    gameView
                    buttonPanel
                }
            }
        }
        .font(.title3)
    }
    
    //======Стол для игры=======
    var gameBoard: some View {
        Rectangle().fill() //фон рабочего стола
            .ignoresSafeArea()
            .foregroundColor(Color(hue: 0.353, saturation: 0.664, brightness: 0.59))
            .onTapGesture {
                game.tapOnBackground()
                dealCards(game.cards)
            }
    }
    
    //==== Сетка катр и анимация=====
    var gameView: some View {
        GeometryReader { geometry in
            ZStack {
                AspectVGrid (items: game.cards, aspectRatio: 2/3) { card in
                    //важно для анимации последовательной раздачи катр
                    if isUndealt(card)  {
                        Color.clear
                    } else {
                        CardView(setMode: game.setMode, card: card)
                            .transition(AnyTransition
                                  .asymmetric(
                                      insertion: AnyTransition.offset(flyFrom(for: geometry.size)),
                                      removal: AnyTransition.offset(flyTo(for: geometry.size))
                                        /*.combined(with: AnyTransition.scale(scale: 0.5))*/))
                            .animation(Animation.easeInOut(duration: 0.5)
                                        .delay(transitionDelay(card: card)))
                            .foregroundColor(game.cardColor(card))
                            .onTapGesture {
                                game.choose(card)
                                //dealCards(game.cards)//теперь автомат
                            }
                    }
                }
                .onAppear {
                    dealCards(game.cards)
                }
                .padding(5)
                
                //надпись SET NOT_SET
                if game.setMode == .b {
                    Text("SET!")
                        .transition(AnyTransition.asymmetric(
                            insertion: AnyTransition.offset(CGSize(width: -geometry.size.width, height: 0.0)),
                            removal: AnyTransition.offset(CGSize(width: geometry.size.width, height: 0.0))))
                        .animation(.easeInOut(duration: 2.0))
                        .font(Font.custom("Chango-Regular", size: geometry.size.width / 10))
                        .foregroundColor(.yellow)
                        .offset(y: geometry.size.height / 2 - geometry.size.width / 10)
                        .zIndex(1.0)
                } else if game.setMode == .c {
                    Text("NOT SET!")
                        .transition(AnyTransition.asymmetric(
                            insertion: AnyTransition.offset(CGSize(width: geometry.size.width, height: 0.0)),
                            removal: AnyTransition.offset(CGSize(width: -geometry.size.width, height: 0.0))))
                        .animation(.easeInOut(duration: 2.0))
                        .font(.custom("Chango-Regular", size: geometry.size.width / 10))
                        .offset(y: geometry.size.height / 2 - geometry.size.width / 10)
                        .foregroundColor(.orange)
                        .zIndex(1.0)
                        .onAppear {
                            timer()
                        }
                }
                
                //надпись бонусы, штрафы
                if game.bonus < 0 {
                    Text("Penalty Points")
                        .transition(AnyTransition.asymmetric(
                            insertion: AnyTransition.offset(CGSize(width: -geometry.size.width, height: 0.0)),
                            removal: AnyTransition.offset(CGSize(width: geometry.size.width, height: 0.0))))
                        .animation(.easeInOut(duration: 2.0))
                        .font(Font.custom("Chango-Regular", size: geometry.size.width / 12))
                        .foregroundColor(.yellow)
                        .offset(y: geometry.size.height / 2 - geometry.size.width / 10)
                        .zIndex(1.0)
                        .onDisappear {
                            score = game.score
                        }
                    Text("\(game.bonus)")
                        .transition(AnyTransition.asymmetric(
                            insertion: AnyTransition.offset(CGSize(width: 0.0, height: geometry.size.height)),
                            removal: AnyTransition.offset(CGSize(width: 0.0, height: -geometry.size.height - 100))))
                        .animation(.easeInOut(duration: 1.0))
                        .font(.custom("Chango-Regular", size: geometry.size.width / 10))
                        .offset(y: geometry.size.height / 2)
                        .foregroundColor(.orange)
                        .onAppear {
                            timer()
                        }
                        .onDisappear {
                            score = game.score
                        }
                        .zIndex(1.0)
                } else if game.bonus > 0 {
                    Text("+\(game.bonus)")
                        .transition(AnyTransition.asymmetric(
                            insertion: AnyTransition.offset(CGSize(width: 0.0, height: geometry.size.height)),
                            removal: AnyTransition.offset(CGSize(width: 0.0, height: -geometry.size.height - 100))))
                        .animation(.easeInOut(duration: 1.0))
                        .font(.custom("Chango-Regular", size: geometry.size.width / 10))
                        .offset(y: geometry.size.height / 2)
                        .foregroundColor(.orange)
                        .onAppear {
                            timer()
                        }
                        .onDisappear {
                            score = game.score
                        }
                        .zIndex(1.0)
                }
                //конец игры
                if game.gameOver {
                    gameOver
                        .transition(AnyTransition.asymmetric(
                            insertion: AnyTransition.offset(CGSize(width: 0.0, height: geometry.size.height)),
                            removal: AnyTransition.offset(CGSize(width: 0.0, height: -geometry.size.height))))
                        .animation(.easeInOut(duration: 1.0))
                        .zIndex(1.0)
                }
            } //end ZStack
        } //end GeometryReader
    }
     
    //надпись конец игры
    var gameOver: some View {
        VStack {
            Text("Game Over!")
                .transition(.opacity)
                .animation(.easeInOut(duration: 2.0))
                .font(.custom("Chango-Regular", size: 45))
                .foregroundColor(.pink)
            Text("Your score: \(game.score)")
                .transition(.opacity)
                .animation(.easeInOut(duration: 2.0))
                .font(.custom("Chango-Regular", size: 35))
                .foregroundColor(.yellow)
        }
    }
    
    //вид верхней панели
    var topPanel: some View {
        HStack {
            Text("Score: \(score)")
            Spacer()
            Text("SET").foregroundColor(
                game.setIs ? Color.yellow : Color.clear)
            Spacer()
            Text("Deck: \(game.cardsDeck.count)")
        }
        .foregroundColor(.yellow)
        .padding(.horizontal)
    }
    
    //вид нижней панели
    var buttonPanel: some View {
        VStack {
            /*
            HStack {
                VStack {
                    //Text("Adam").font(.largeTitle)
                    buttonPlayer1.padding().font(Font.system(size: 60))
                }
                Spacer()
                VStack {
                    //Text("Eva").font(.largeTitle)
                    buttonPlayer2.padding().font(Font.system(size: 60))
                }
            }
            */
            HStack {
                buttonNewGame
                Spacer()
                buttonDeal3Card
            }
        }
        .padding()
        .foregroundColor(.yellow)
    }
    
    //кнопка сдачи 3 доп карт
    var buttonDeal3Card: some View {
        ZStack {
            Button("Deal 3 Cards") {
                if !block {
                    block = true //временная блокировка раздачи доп. 3 карт до конца анимации
                    game.deal3MoreCards()
                    dealCards(game.cards)
                } else {
                    block = false //разблокировка раздачи доп. 3 карт
                }
            }
            .buttonStyle(CapsuleButton())
            //.buttonStyle(ColorButton(sets: game.setIs)) //цвет кнопки меняется если есть сет на столе
        }
    }
    
    //кнопка новоя игра
    var buttonPlayer1: some View {
        Button("🙎‍♂️") {
            
        }
        .buttonStyle(GrowingButton())
    }
    
    //кнопка новоя игра
    var buttonPlayer2: some View {
        Button("🙍‍♀️") {
            
        }
        .buttonStyle(GrowingButton())
    }
    
    //кнопка подсказка о количестве сетов
    /*
    var buttonHint: some View {
        var hint = ""
        if hintView {
            hint = "\(game.sets)"
        } else {
            hint = "-"
        }
        return Button(hint) {
            hintView.toggle()
        }.buttonStyle(TestButton())
    }
    */
    
    //кнопка новоя игра
    var buttonNewGame: some View {
        Button("New Game") {
            game.restart() //инициализация модели
            score = 0 //сброс счета
            dealCards(game.cards) //раздача карт
        }
        .buttonStyle(CapsuleButton())
    }
    
    //===============Struct=Methods======================
    //сдача всех карт массива cards остальные в колоде
    private func dealCards(_ cards: [SetGameViewModel.Card]) {
        shouldDelay = true
        timer1()
        for card in cards {
            dealt.insert(card.id)
        }
        block = false //разблокировка сдачи доп карт
    }
    
    //расчет паузы для анимации сдачи карт по одной, по ее индексу в массиве карт
    private func transitionDelay(card: SetGameViewModel.Card) -> Double {
        guard  shouldDelay else {return 0.0}
        return Double(game.cards.firstIndex(where: {$0.id == card.id})!) * 0.1
    }
    
    //если нет в наборе - карта не сдана используется для посл. разд карт
    private func isUndealt(_ card: SetGameViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    //формирование сдачи карт по одной - не применяется пока
    private func dealAnimation(for card: SetGameViewModel.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (2 / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: 0.5).delay(delay)
    }
    
    //позиция откуда приходят карты на экран
    private func flyFrom(for size:CGSize) -> CGSize {
        //сейчас идут прямо снизу вверх
        return CGSize(width: 0.0/*CGFloat.random(in: -size.width/2...size.width/2)*/,
               height: size.height)
    }
    
    //позиция куда уходят карты с экрана
    private func flyTo(for size:CGSize) -> CGSize {
        //уходят в случайно выбранные позиции
        return CGSize(width: CGFloat.random(in: -3*size.width...3*size.width),
               height: CGFloat.random(in: -2*size.height...(-size.height)))
    }
    
    //таймер запускающий действие через 2.5 сек
    private func timer() {
        _ = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) {_ in
            game.tapOnBackground()
            dealCards(game.cards)
        }
    }
    
    //таймер запускающий действие через 2.5 сек
    private func timer1() {
        _ = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) {_ in
            shouldDelay = false
        }
    }
}

//вид карты
struct CardView: View {
    var setMode:Triple
    var card: SetGameModel.Card
    var fgColor: Color = .white
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 10.0)
        ZStack {
            shape.fill().foregroundColor(.white)
            if card.isChoose {
                switch setMode {
                case .a://default
                    shape.fill().foregroundColor(.yellow).opacity(0.2) //yellow
                    shape.strokeBorder(lineWidth: 5.0).foregroundColor(Color(red: 218/255, green: 207/255, blue: 37/255)) //yellow
                case .b://set
                    shape.fill().foregroundColor(.blue).opacity(0.2) //blue
                    shape.strokeBorder(lineWidth: 5.0).foregroundColor(Color(red: 0.376, green: 0.678, blue: 0.771)) //blue
                case .c://not set
                    shape.fill().foregroundColor(.pink).opacity(0.2) //pink
                    shape.strokeBorder(lineWidth: 5.0).foregroundColor(Color(red: 0.955, green: 0.546, blue: 0.606)) //pink
                }
            } else {
                shape.stroke(lineWidth: 2.0).foregroundColor(.black)
            }
            //карт контент
            SetGameViewModel.cardConent(card).padding(10)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}
