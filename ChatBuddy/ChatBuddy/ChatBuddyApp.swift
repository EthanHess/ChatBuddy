//
//  ChatBuddyApp.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 1/6/26.
//

import SwiftUI

@main
struct ChatBuddyApp: App {
    
    //MARK: Top level / App entry point, most shared objects (environment etc.) should go here to not be nested too deep unless there's a good reason
    
    //Also won't be created multiple times 
    
    @State private var messageController : MessageController
    @State private var slm = SmallLanguageModel()
    
    init() {
        let languageModel = SmallLanguageModel()
        _slm = State(initialValue: languageModel)
        _messageController = State(initialValue: MessageController(slm: languageModel))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(slm)
                .environment(messageController)
        }
    }
}
