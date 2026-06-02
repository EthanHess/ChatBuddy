//
//  MessageController.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 1/6/26.
//

import SwiftUI
import Observation

//MARK: New way to observe
@Observable
class MessageController  {
    
    let slm : SmallLanguageModel
    
    //DI ftw
    init(slm: SmallLanguageModel) {
        self.slm = slm
    }
    
    var messages : [Message] = []
    var isSending = false
    
    func addMessage(_ body: String, authorUID: Int) {
        if isSending == true { return }
        isSending = true
        let message = Message(id: messages.count, messageBody: body, authourUID: authorUID)
        messages.append(message)
    
        //async = generally weakify
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            let res = slmTest(body)
            let resMessage = Message(id: messages.count, messageBody: res, authourUID: 1)
            messages.append(resMessage)
            isSending = false
        }
    }
    
    //MARK: Put slm top level
    private func slmTest(_ input: String) -> String  {
        slm.trainModel(input: input)
        
        //assume it's a sentence with spaces (add guard to check eventually)
        guard let firstWord = input
            .split(whereSeparator: \.isWhitespace)
            .first.map(String.init) else { return "" }
        let rep = slm.generateResponse(start: firstWord)
        return rep
    }
}


struct Message : Identifiable {
    var id: Int
    var messageBody : String
    var authourUID : Int
}
