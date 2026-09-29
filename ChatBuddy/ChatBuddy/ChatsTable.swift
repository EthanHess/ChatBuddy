//
//  ChatsTable.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 9/29/26.
//

import SwiftUI
 
struct ChatsTable: View {
    //Should live top level, rearchitect after test
    @State private var chatsController = ChatsController()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(chatsController.chats) { chat in
                        NavigationLink(destination: ChatView(chat: chat)) {
                            ChatCell(chat: chat)
                        }
                    }
                }
            }
            .navigationTitle("Chats")
            .toolbar {
                Button("New Chat") {
                    _ = chatsController.createChat()
                }
            }
        }
    }
}



struct ChatCell: View {
    let chat: Chat
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(chat.title)
                    .font(.headline)
                Text(chat.messages.last?.messageBody ?? "No messages yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }.padding().foregroundStyle(.white)
            Spacer()
        }.padding().neon(.allCases.randomElement() ?? .red)
    }
}


@Observable
class ChatsController {
    var chats: [Chat] = []
    
    //Todo add name param. or option to write name on create & persist data but UI looks good :)
    func createChat() -> Chat {
        let chat = Chat()
        chats.append(chat)
        return chat
    }
    
    func deleteChat(_ chat: Chat) {
        chats.removeAll { $0.id == chat.id }
    }
}
