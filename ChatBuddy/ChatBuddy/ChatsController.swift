//
//  ChatsController.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 10/6/26.
//

import SwiftUI

@Observable
class ChatsController {
    var chats: [Chat] = []
    
    private var saveURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("chats.json")
    }
    
    init() {
        loadChats()
    }
    
    func createChat() -> Chat {
        let chat = Chat()
        chats.append(chat)
        saveChats()
        return chat
    }
    
    func deleteChat(_ chat: Chat) {
        chats.removeAll { $0.id == chat.id }
        saveChats()
    }
    
    func saveChats() {
        if let data = try? JSONEncoder().encode(chats) {
            try? data.write(to: saveURL)
        }
    }
    
    func loadChats() {
        guard let data = try? Data(contentsOf: saveURL),
              let decoded = try? JSONDecoder().decode([Chat].self, from: data) else { return }
        chats = decoded
    }
}
