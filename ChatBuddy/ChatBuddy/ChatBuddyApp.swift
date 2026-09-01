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
    
    //MARK: layers = processing steps in an llm
    
    //MARK: 6 = input size (only with flat map, aside from that it would be 3), 4 = hidden layer -> 4 neurons (numbers in this case) 6 down (embedding size), 3 = output size, in this case the "cat" token 
    
    //MARK: TODO test with [3, 4, 3]
    @State private var messageController : MessageController
    @State private var nlm = NeuralLanguageModel(layerSizes: [3, 8, 10])
    
    init() {
        
        let languageModel = NeuralLanguageModel(layerSizes: [3, 8, 10])
        _nlm = State(initialValue: languageModel)

        _messageController = State(initialValue: MessageController(nlm: languageModel))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(nlm)
                .environment(messageController)
        }
    }
}
