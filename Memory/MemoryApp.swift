//
//  MemoryApp.swift
//  Memory
//
//  Created by Parshkova Daria on 05.07.2021.
//

import SwiftUI
@main
struct MemoryApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
//отсылка к contentView @ObservedObject var viewModel : EmojiMemoryGame
