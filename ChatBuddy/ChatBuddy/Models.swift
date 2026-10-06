//
//  Models.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 9/29/26.
//

import SwiftUI

struct Chat: Identifiable, Codable {
    let id: UUID
    var title: String
    var messages: [Message]
    var createdAt: Date
    
    init(title: String = "New Chat") {
        self.id = UUID()
        self.title = title
        self.messages = []
        self.createdAt = Date()
    }
    
    mutating func updateTitleIfNeeded() {
        guard title == "New Chat", let firstMessage = messages.first else { return }
        title = String(firstMessage.messageBody.prefix(30))
    }
}
