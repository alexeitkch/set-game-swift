//
//  Set_GameApp.swift
//  Set Game
//
//  Created by Aleksey on 3/14/23.
//

import SwiftUI

@main
struct Set_GameApp: App {
    var game = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
