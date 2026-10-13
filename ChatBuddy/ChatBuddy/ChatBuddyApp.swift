//
//  ChatBuddyApp.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 1/6/26.
//

import SwiftUI

@main
struct ChatBuddyApp: App {
    @State private var nlm = NeuralLanguageModel(layerSizes: [3, 8, 10])
    @State private var chatsController = ChatsController()

    var body: some Scene {
        WindowGroup {
            ChatsTable()
                .environment(nlm)
                .environment(chatsController)
                .onAppear { nlm.prepare() }  // trains once, see below
        }
    }
}
