//
//  MemoryGame.swift
//  Memory
//
//  Created by Parshkova Daria on 08.07.2021.
//

//это модель
import Foundation
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards : Array<Card>
    private var indexOfTheOneAndOnlyFaceUpCard : Int? {
        get { return cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
            set { cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue)}} }
    mutating func choose(_ card: Card)  {
        // так как это тип Card а не Intб,  String то необязательно указывать имя как card
        //лучше использовать имя без ключевого слова
        //это единственная функция которая может изменить isFaceUp and IsMatched\
    //функция отражает намерение пользователя и выполняет след команды
        
        if let chosenIndex = cards.firstIndex(where: { $0.id  == card.id}) ,
           !cards[chosenIndex].isFaceUp ,
           !cards[chosenIndex].isMatched
        {
            if let potentionalMathcIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentionalMathcIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentionalMathcIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    mutating func shuffle() {
        cards.shuffle()
    }
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent)
    // createCardContent: (Int) -> CardContent) мы передаем функцию  этой функции этой функции(1) инициализации и она будет создавать необхрдимиый CardContent)
    //и нам надо предоставить этот аргумент в Vm
    //1
    {
        cards = []
        // это создаст пустой массив карт
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex) // это функция возвратит тип CardContent
            cards.append(Card(content: content, id:pairIndex*2)) //добавляем карту в массив
            cards.append(Card(content: content, id:pairIndex*2+1))
            //add numberOfCardsPairsOfCards x 2 to crads arr - slozhit chislo par cartochek umnozhit na 2 kartochki v cards massive
                //mu polnostiu zdes inicializirovalis
            //id это идентификация по Int
        }
        cards.shuffle()
    }
    //1
    
    // как только мы инициализировали хотя бы одну переменную в структурк то теряем все бесплатные инициализаторы
    //inicializiruem vse ustanovlennue peremennue
    struct Card : Identifiable {
        //делаем карты идентифицуруемыми
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        } //открыта карта или закрыта
        var isMatched = false  {
            didSet {
                stopUsingBonusTime()
            }
        }//совпадение карты с другими
        let content : CardContent // содержимое карты - CardContent означает - пофиг, в таком случаем надо указать в угловых скобках у структуры 1-й  потому что когда ктр-то использует игру нашу игру на память - он должен сказать - что это за пофиг это не может быть все время безразличным
        let id : Int
        // карта будет идентифицироваться по типу инт
        //content и id никогда не изменятся
    //положив карту в эту структуру - мы поясняем что это карта которая входит в игру на запоминание
        
    // MARK: - Bonus Time

    // this could give matching bonus points
    // if the user matches the card
    // before a certain amount of time passes during which the card is face up

    // can be zero which means "no bonus available" for this card
    var bonusTimeLimit: TimeInterval = 6

    // how long this card has ever been face up
    private var faceUpTime: TimeInterval {
        if let lastFaceUpDate = self.lastFaceUpDate {
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }
    // the last time this card was turned face up (and is still face up)
    var lastFaceUpDate: Date?
    // the accumulated time this card has been face up in the past
    // (i.e. not including the current time it's been face up if it is currently so)
    var pastFaceUpTime: TimeInterval = 0

    // how much time left before the bonus opportunity runs out
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - faceUpTime)
    }
    // percentage of the bonus time remaining
    var bonusRemaining: Double {
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
    }
    // whether the card was matched during the bonus time period
    var hasEarnedBonus: Bool {
        isMatched && bonusTimeRemaining > 0
    }
    // whether we are currently face up, unmatched and have not yet used up the bonus window
    var isConsumingBonusTime: Bool {
        isFaceUp && !isMatched && bonusTimeRemaining > 0
    }

    // called when the card transitions to face up state
    private mutating func startUsingBonusTime() {
        if isConsumingBonusTime, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }
    // called when the card goes back face down (or gets matched)
    private mutating func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        self.lastFaceUpDate = nil
        }
    }
}
extension Array {
    var oneAndOnly : Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}


