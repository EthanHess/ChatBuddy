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
                            ChatCell(chat: chat, onDelete: {
                                chatsController.deleteChat(chat)
                            })
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Chats")
            .toolbar {
                Button("New Chat") {
                    _ = chatsController.createChat()
                }
            }
        }
    }
}

//MARK: Only works on list but this could be cool

//    .swipeActions(edge: .trailing) {
//        Button(role: .destructive) {
//            chatsController.deleteChat(chat)
//        } label: {
//            Label("Delete", systemImage: "trash")
//        }
//    }



struct ChatCell: View {
    let chat: Chat
    let onDelete: () -> Void
    
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
            Button {
                onDelete() //Present alert, in real production this is not an ideal way to do this but is okay for testing
            } label: {
                Image(systemName: "trash")
                .foregroundStyle(.red)
            }.buttonStyle(.plain)
        }.padding().neon(.allCases.randomElement() ?? .red)
    }
}
