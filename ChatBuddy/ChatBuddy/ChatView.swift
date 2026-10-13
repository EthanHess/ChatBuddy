//
//  ChatView.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 9/29/26.
//

import SwiftUI


struct ChatView : View {
    //MARK: Current logic from content view will be moved here, add message controller and sync / store messages from chat
    
//    @Environment(NeuralLanguageModel.self) private var nlm
    @State private var messageController: MessageController
    @State private var curText = ""
    let chat: Chat

    init(chat: Chat, nlm: NeuralLanguageModel, chatsController: ChatsController) {
        self.chat = chat
        _messageController = State(initialValue:
            MessageController(nlm: nlm, chatsController: chatsController, chatID: chat.id))
    }
    
    var body : some View {
        VStack {
            HStack {
                Button("Clear model") {
                    messageController.clearData()
                }.padding().redNeon.foregroundStyle(.red)
                Button("Print") {
                    messageController.printTest()
                }.padding().redNeon.foregroundStyle(.red)
            }.padding()
//            if messageController.isTraining {
//                ProgressView("Training model...")
//            }
            Spacer()
            //SV -> LVS more versatile than List in some cases, especially for custom layouts
            //NOTE: lazy lazily loads views but not necessarily data
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        //MARK: messages for chat + persistent store
                        ForEach(messageController.messages) { message in
                            Spacer()
                            MessageBubble(authorUID: message.authourUID, messageBody: message.messageBody).frame(maxWidth: .infinity, maxHeight: 100).padding()
                            
                            //MARK: Messages will appear when added but if we ever reload the entire chat may want to paginate (on view appear)
                            
                            Spacer()
                        }
                    }
                }.onChange(of: messageController.messages.count) { oldValue, newValue in
                    guard let last = messageController.messages.indices.last else { return }
                    withAnimation {
                        //Needs to scroll a bit lower
                        proxy.scrollTo(last, anchor: .bottom)
                    }
                }
            }
            Spacer()
            if messageController.isSending { AnimatingUploadLine().frame(height: 25) }
            TextFieldContainer(curText: $curText, messageController: messageController)
            Spacer()
        }
        .padding()
    }
}
