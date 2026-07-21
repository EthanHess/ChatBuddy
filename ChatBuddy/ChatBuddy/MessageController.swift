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
    
//    let slm : SmallLanguageModel
//    
//    //DI ftw
//    init(slm: SmallLanguageModel) {
//        self.slm = slm
//    }
    
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
            //let res = slmTest(body)
    //        let res = "OMG Hey what's up n00b I'm a chatbot"
           // let res = nlmTest(body)
            let res = generateSentence(start: body)
            let resMessage = Message(id: messages.count, messageBody: res, authourUID: 1)
            messages.append(resMessage)
            isSending = false
        }
    }
    
    //MARK: Put slm top level
//    private func slmTest(_ input: String) -> String  {
//        slm.trainModel(input: input)
//        
//        //assume it's a sentence with spaces (add guard to check eventually)
//        guard let firstWord = input
//            .split(whereSeparator: \.isWhitespace)
//            .first.map(String.init) else { return "" }
//        let rep = slm.generateResponse(start: firstWord)
//        return rep
//    }
    
    
    //MARK: New model test
    let nlm : NeuralLanguageModel
    
    init(nlm: NeuralLanguageModel) {
        self.nlm = nlm
        
        setUpTestData()
        trainModel()
    }
    
    //MARK: May need more iterations for more accurate response
    
    private func trainModel() {
        let sequence = ["cat", "sat", "on", "the", "mat"]
            
        // train on consecutive pairs
        for i in 0..<sequence.count - 1 {
            let input = sequence[i]
            let targetIndex = nlm.tokens.firstIndex(of: sequence[i + 1]) ?? 0
                
            for _ in 0..<1000 {
                nlm.train(input: [input], targetIndex: targetIndex, learningRate: 0.01)
            }
        }
    }
    
    private func generateSentence(start: String, maxLength: Int = 5) -> String {
        var result = [start]
        var currentToken = start
        
        for _ in 0..<maxLength {
            let nextToken = nlmTest(currentToken)
            if nextToken == currentToken { break } //need to stop at some point or this'll go forever
            result.append(nextToken)
            currentToken = nextToken
        }
        
        return result.joined(separator: " ")
    }
    
    private func setUpTestData() {
        nlm.tokens = ["cat", "sat", "on", "the", "mat"]
        nlm.embeddings = [
            "cat": [0.8, 0.2, 0.1],
            "sat": [0.3, 0.9, 0.2],
            "on":  [0.1, 0.1, 0.5],
            "the": [0.1, 0.1, 0.1],
            "mat": [0.7, 0.3, 0.4]
        ]
    }
    
    private func nlmTest(_ input: String) -> String  {
        //[String]
        let tokens = input.split(whereSeparator: \.isWhitespace).map(String.init)
        //returning Vector (which is [Float])
        let probabilities = nlm.forward(tokens)
        
        //highest propbability (token)
        guard let maxIndex = probabilities.indices.max(by: { probabilities[$0] < probabilities[$1] }) else { return "" }
        return nlm.tokens[maxIndex]
    }
}


struct Message : Identifiable {
    var id: Int
    var messageBody : String
    var authourUID : Int
}
