//
//  Models.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 9/29/26.
//

import SwiftUI

struct Chat: Identifiable {
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
}
