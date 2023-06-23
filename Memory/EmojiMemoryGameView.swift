//
//  ContentView.swift
//  Memory
//
//  Created by Parshkova Daria on 05.07.2021.
//

import SwiftUI
    struct EmojiMemoryGameView: View {
        @ObservedObject var game : EmojiMemoryGame
        @Namespace private var dealingNamespace //пространство имен используется только внутри нашего представления
 
        var body : some View {
        ZStack(alignment: .bottom) {
        VStack {
           gameBody
            HStack {
                newGameButton
                Spacer()
                Text("\(game.score)").foregroundColor(.blue).padding(.horizontal)
                
        }
        .padding(.horizontal)
            }
            deckBody
        }
    }
    @State private var dealt = Set<Int>() // переменная называемая раздачей чтобы отслеживать свои карты, котор будет набором значений, кот являются идентификаторами моих карт.когда я раздаю свои карты - я добавляю id в этот набор и таким образом узнаю была ли карта сдана
    private func deal(_ card : EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    //вставляет карту в разданный набор - set
    private func isUndealt(_ card : EmojiMemoryGame.Card) -> Bool {
      !dealt.contains(card.id)
    }
    //contains - функция в наборе - set, которая говорит содержит ли этот набор идентификатор(id)
        
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0 // задержка с которой мы раздаем карту 
        if let index = game.cards.firstIndex( where: { $0.id == card.id } ) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
        //он берет определенную карту и вернет анимацию которую будет использована для раздачи этой карты
    private func zIndex(of card:EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    //когда у вас есть карты и вы хотите чтобы они были в определенном порядке по отношению к пользователю вы можете использовать это VM, карты будут раздаваться сверху колоды

        
    
    var gameBody: some  View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
                //CLEAR это прозрачны цвет
            } else {
                CardView(card:card, color:.clear)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    //для того чтобы карточки красиво раздавались
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of:card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        
      
         //способ позволяющий не выводить View на экран до тех пор пока не появится его контейнер это в случей если хотим чтобы наши карточки плавно появлялись из точкм а не раскидывались
     
        .foregroundColor(game.theme.color)
    }
        var shuffle: some View {
            Button("Shauffle")
            { withAnimation {
                game.shuffle()
            }
        }
    }
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card:card, color : nil)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex (of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth , height: CardConstants.undealtHeight)
        .foregroundColor(game.theme.color)
        .onTapGesture  {
            // "deal" cards
            for card in game.cards {
            withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
        //способ позволяющий не выводить View на экран до тех пор пока не появится его контейнер это в случей если хотим чтобы наши карточки плавно появлялись из точкм а не раскидывались это наш onAppar
    }
    //это наша колода раздающая карты
        //блягодаря этой анимации карточки собираются обратно в колоду при перезапуске игры
    
    
    var newGameButton : some View {
        Button("new game") {
        withAnimation {
            dealt = [] //возвращаем свой сданные сет в обратный пустой режим и когда у нас меняется дело в моем представлении применится @State, таким образом изменение этого параметра приведет к появлению операции
            game.didTouchNewGameButton()
            }
            //будет возвращать нашу карточку посредине после перезапуска игры
        }
    }
    private struct CardConstants {
        static let color : Color = .red
        static let aspectRatio : CGFloat = 2/3
        static let dealDuration : Double = 0.5
        static let totalDealDuration : Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
  
}


struct  CardView : View {
    let card: EmojiMemoryGame.Card
    private var color:Color?
    @State private var animatedBonusRenaming : Double = 0
    var body : some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                if card.isConsumingBonusTime {
                    Pie(startAngle:Angle(degrees: 0-90) , endAngle:Angle(degrees: (1-animatedBonusRenaming)*360-90))
                        .onAppear() {
                            animatedBonusRenaming = card.bonusRemaining
                            withAnimation(.linear(duration:  card.bonusTimeRemaining)) {
                                animatedBonusRenaming = 0
                            }
                        }
                } else {
                    Pie(startAngle:Angle(degrees: 0-90) , endAngle:Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .padding(5)
                .opacity(0.5)
                    Text(card.content)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                        .padding(5)
                        .font(Font.system(size:DrawingConstants.fontSize))
                        .scaleEffect(scale(thatFits: geometry.size))
            }
        .cardify(isFaceUp: card.isFaceUp)
        .transition(AnyTransition.scale)
        }
        
    }
    
    
    
    @State private var animatedBonusRemaining: Double = 0
    private func startBonusTimeAnimation() {
        animatedBonusRenaming = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusRemaining)) {
            animatedBonusRenaming = 0
        }
    }
    
    init(card:MemoryGame<String>.Card, color:Color?) {
        self.card = card
        self.color = color
    }
    
    private func scale(thatFits size : CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale : CGFloat = 0.7
        static let fontSize : CGFloat = 32
    }
   
}
   
//@ViewBuilder
//private func cardView(for card: EmojiMemoryGame.Card) -> some View {
//    if card.isMatched && !card.isFaceUp {
//       Rectangle().opacity(0)
//    } else {
//        CardView(card: card)
//        .padding(4)
//        .onTapGesture {
//           game.choose(card)
//
//        }
//    }
//}
struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            let game = EmojiMemoryGame()
            //создаю игру и передаю как Vm
            game.choose(game.cards.first!)
            return EmojiMemoryGameView(game:game)
           // EmojiMemoryGameView( game: EmojiMemoryGame())
        }
    
}
private func fontSize(for size:CGSize) -> CGFloat {
    min(size.width, size.height) * 0.7
}
