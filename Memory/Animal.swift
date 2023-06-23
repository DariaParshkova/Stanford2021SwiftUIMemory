//
//  Animal.swift
//  Memory
//
//  Created by Parshkova Daria on 07.07.2021.
//

import SwiftUI

struct Animal: View {

    @State var  emogies1 = ["🔴", "🟠", "🟢", "🟣", "🟩","🔺", "🪰", "🐞"].shuffled()
    
    @State var correctAnswer = Int.random(in:0..<7)
    @State var emojiCount : Int = 16
    
    func askQuestion() {
        emogies1.shuffle()
        correctAnswer = Int.random(in: 0..<7)
    }
    @Environment (\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Text("Memorize")
                .font(.largeTitle)
            ScrollView {
                LazyVGrid(columns:[GridItem(.adaptive(minimum:65))]) {
                ForEach(emogies1[0..<emojiCount], id:\.self) { emoji in
                    CardView1(content:emoji).aspectRatio(2/3, contentMode:.fit)
                    
                    }
                }
            }
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label : {
                    Image(systemName: "hexagon")
                }
              
            }
            .foregroundColor(.red)
           
    }
 
}
}

struct  CardView1 : View {
    @State var isFaceUp: Bool = true
    var content: String
    var body : some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
       
    }
}



struct Animal_Previews: PreviewProvider {
    static var previews: some View {
        Animal()
    }
}
