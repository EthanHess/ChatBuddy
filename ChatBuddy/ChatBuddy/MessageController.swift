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
    
    let chatsController: ChatsController
    let chatID: UUID

    var messages: [Message] { chatsController.messages(forChat: chatID) }
    
    var isSending = false
    
    func addMessage(_ body: String, authorUID: Int) {
        if isSending { return }
        isSending = true
        let message = Message(id: messages.count, messageBody: body, authourUID: authorUID)
        chatsController.addMessage(message, toChat: chatID)
    
        //async = generally weakify (for ref. types)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            let res = self.generateSentence(start: body.lowercased())
            let resMessage = Message(id: self.messages.count, messageBody: res, authourUID: 1)
            self.chatsController.addMessage(resMessage, toChat: self.chatID)
            self.isSending = false
        }
    }
    
    //MARK: New model test (can eventually remove and do everything in that model)
    
    let nlm : NeuralLanguageModel
   // var isTraining = false
    
    init(nlm: NeuralLanguageModel, chatsController: ChatsController, chatID: UUID) {
        self.nlm = nlm
        self.chatsController = chatsController
        self.chatID = chatID
        
       // setUpTestData()
       // isTraining = true
        
        //100K iterations for training is a lot and can block the main thread so
//        Task.detached(priority: .userInitiated) { [weak self] in
//            guard let self = self else { return }
//            await self.trainModel()
//            await MainActor.run {
//                self.isTraining = false
//            }
//        }
    
        //sub 50k
      //  trainModel()
    }
    
    //MARK: Eventually take into account whole context (context window)
    
    //context window will be last n tokens (for now prevents input that's too large for what the model was trained on)
    private func generateSentence(start: String, maxLength: Int = 5, contextWindow: Int = 4) -> String {
        var result = [start]
        var context = [start]
        var visited = Set<String>()
        
        for _ in 0..<maxLength {
//            print("Context: \(context)")
            let windowedContext = Array(context.suffix(contextWindow)) //last 4 for now (testing)
            let nextToken = nlmTest(windowedContext)
//            print("Predicted: \(nextToken)")
            if nextToken == "<end>" { break }
            if visited.contains(nextToken) { break }
            visited.insert(nextToken)
            result.append(nextToken)
            context.append(nextToken)
        }
        
        return result.joined(separator: " ")
    }
    
    private func nlmTest(_ tokens: [String]) -> String {
        let probabilities = nlm.forward(tokens)  // forward already supports [String]!
        guard let maxIndex = probabilities.indices.max(by: { probabilities[$0] < probabilities[$1] }) else { return "" }
        return nlm.tokens[maxIndex]
    }
    
    func clearData() {
        nlm.resetModel()
    }
    
    func printTest() {
        //sat: 0.997 <- something like this means model is very confident cat -> sat makes sense
        let probs = nlm.forward(["cat"])
        print("cat probs: \(zip(nlm.tokens, probs).map { "\($0.0): \(String(format: "%.3f", $0.1))" })")
    }
}


struct Message : Identifiable, Codable {
    var id: Int
    var messageBody : String
    var authourUID : Int
}


