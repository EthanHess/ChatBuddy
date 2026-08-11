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
    
    //MARK: New model test
    let nlm : NeuralLanguageModel
    
    init(nlm: NeuralLanguageModel) {
        self.nlm = nlm
        
        setUpTestData()
        trainModel()
    }
    
    //MARK: May need more iterations for more accurate response
    
    private func trainModel() {
        if nlm.loadWeights() { return }
        
        let sequence = ["cat", "sat", "on", "the", "mat"]
        let pairs = zip(sequence, sequence.dropFirst()).map { ($0, $1) }
        
        for _ in 0..<50000 {
            //for (input, target) in pairs { <- can also not shuffle
            for (input, target) in pairs.shuffled() {  // shuffle each epoch (ref. point) so that model knows they can be in different orders
                let targetIndex = nlm.tokens.firstIndex(of: target) ?? 0
                nlm.train(input: [input], targetIndex: targetIndex, learningRate: 0.001)
            }
        }
        
        nlm.saveWeights() //prevents calling above every app launch, especially when we add thousands of words
    }
    
    private func generateSentence(start: String, maxLength: Int = 5) -> String {
        var result = [start]
        var currentToken = start
        
//        for _ in 0..<maxLength {
//            //MARK: Debugging, remove when finished
//            let probs = nlm.forward([currentToken])
//            print("\(currentToken) probs: \(zip(nlm.tokens, probs).map { "\($0.0): \(String(format: "%.3f", $0.1))" })")
//            
//            let nextToken = nlmTest(currentToken)
//            if nextToken == "<end>" { break }
//            if nextToken == currentToken { break } //need to stop at some point or this'll go forever
//            result.append(nextToken)
//            currentToken = nextToken
//        }
        
        var visited = Set<String>()
        
        for _ in 0..<maxLength {
            let nextToken = nlmTest(currentToken)
            if nextToken == "<end>" { break }
            if visited.contains(nextToken) { break }  // catches cycles
            visited.insert(nextToken)
            result.append(nextToken)
            currentToken = nextToken
        }
       
        return result.joined(separator: " ")
    }
    
    private func setUpTestData() {
        nlm.tokens = ["cat", "sat", "on", "the", "mat", "<end>"]
        nlm.embeddings = [
            "cat":   [1.0, 0.0, 0.0],
            "sat":   [0.0, 1.0, 0.0],
            "on":    [0.0, 0.0, 1.0],
            "the":   [0.5, 0.5, 0.0],
            "mat":   [0.0, 0.5, 0.5],
            "<end>": [0.0, 0.0, 0.0]
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
    
    func clearData() {
        nlm.resetModel()
    }
    
    func printTest() {
        //sat: 0.997 <- something like this means model is very confident cat -> sat makes sense
        let probs = nlm.forward(["cat"])
        print("cat probs: \(zip(nlm.tokens, probs).map { "\($0.0): \(String(format: "%.3f", $0.1))" })")
    }
}


struct Message : Identifiable {
    var id: Int
    var messageBody : String
    var authourUID : Int
}
