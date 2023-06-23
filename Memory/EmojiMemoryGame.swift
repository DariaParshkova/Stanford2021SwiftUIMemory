//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Parshkova Daria on 08.07.2021.
//

import SwiftUI
// это ViewModel - является частью пользовательского интерфейса, но это не часть представления
// её задача быть посредником между моделью и представлением, View Model собирается создать свою собственную модель Иногда Модель это уже существующая сетевая база данных и она просто собиратся подключиться к ней. Но часто он создает модель к которой он предоставляет окно, и задача ViewModel - либо заставить эту вещь сохраняться на диске или в сети. Но для игры в память достаточно тогго что игра просто исчезает когда эта ViewModel уходит. Mы часто будем говорить что представления VM будут truth.
class EmojiMemoryGame : ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    public var theme: Theme {
        model.theme
    }
    public var score : Int {
        Int(model.score)
    }
    //Лучше не использовать глобальную переменную так как к ней имею доступ все, для того чтобы сделать переменную в рамках нашего пространства пишем STATIC - по существу она глобальн
    @Published private var model : MemoryGame<String>!
    
    private static func createMemoryGame(theme:Theme) -> MemoryGame<String> {
        let emojis = theme.cardContent
        let memoryGame = MemoryGame<String>(theme: theme , numberOfPairsOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
        memoryGame.cards.shuffled()
        return memoryGame
    }
    init(theme:Theme? = nil ) {
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme ?? EmojiMemoryGame.themes.randomElement()!)
    }
    //предоставляем функцию, которая сделает параметр createCardContent
    //в данном случак STATIC - подчеркивает что эта функция на самом деле функция того де типа EmojiMemoryGame, не экземпляпв а сам тип имеет эту
    //функцию или переменную
    //emoji - это строки
    //Задача VM защищать модель от некорректных представлний, один из таких способов сделать ее private -  она model может видеть только сам код VM. Это контроль доступа.

// в структура var могут существовать без значений, но в классе так нельзя
    var cards: Array<Card> {
        return model.cards
    }
    //имеет собственные карты и можеть возвращать карты модели, это структура, и массивы и карты это структры когда мы передаем структуры мы их копируем. Когда кто-то попросит здест VM карты в модели  нам нужно будет получить новую копию. Поэтому нам нужна эта функция, кажды раз когда кто-то просит карточки VM. 
    // MARK: - Intent(s)
    func choose(_ card : Card) {
        model.choose(card:card)
        //наша модель позволяет нам напрямую выбирать карту
    }
    func beginNewGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: randomDifferentTheme)
    }
    func didTouchNewGameButton() {
        beginNewGame()
    }
    func shuffle()  {
        model.shuffle()
    }
    private var  randomDifferentTheme : Theme {
        let randomDifferentThemes = EmojiMemoryGame.themes.filter {$0.name != theme.name}
        return randomDifferentThemes.randomElement()!
    }
    //это намерение - то что мы собираемся получить Ui интерфейс непосредственно к нашему польз интерфейсу
}

extension EmojiMemoryGame {
    typealias Theme = MemoryGame<String>.Theme
    static var themes : [Theme] { [
        Theme(name:"Hallowen", cardContent: ["🎃","😈","👻","🧛‍♀️","🔮","🖤","💀","🧡","💫","🌓","🧟‍♀️","🧚"], numberOfCards: 3, color: .orange),
        Theme(name: "Animals", cardContent: ["🐶","🐱","🐸","🐰","🐻","🐵","🦊","🐮","🐤","🦄"], numberOfCards: 2, color: .purple),
        Theme(name: "Transport", cardContent: ["🚂", "🚁", "🚀", "🚜","🚒","🛳","🛸", "🚠","✈️","⛵️"], numberOfCards: 2, color: .red),
        Theme(name: "Sea", cardContent: ["🌊","🦋","🦀","☀️","🧜‍♀️","🕶","👙","👒","🐙","🌈"], numberOfCards: 2, color: .blue),
        Theme(name: "Eat", cardContent: ["🍏","🥑","🍋","🍉","🍑","🍍","🍕","🍔"], numberOfCards: 2, color: .yellow),
        Theme(name: "Medecine", cardContent: ["🫁","🧠","👁","🦾","🦷","💊","🩺","🧬","🧪","🔬"], numberOfCards: 2,color: .green),
        Theme(name: "IT", cardContent: ["💻","💿","🕹","💡","📡","⌨️","💳","📱","🔐","⌚️","🖥"], numberOfCards: 2, color: .blue),
        Theme(name: "Hurt", cardContent: ["❤️","🖤","💚","💙","💜","🧡","💛","🤍","💖","🫀"], numberOfCards: 2, color: .pink)
    ]}
}

