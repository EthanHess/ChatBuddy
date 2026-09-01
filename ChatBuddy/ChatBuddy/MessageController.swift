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
    
        //async = generally weakify (for ref. types)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            let res = generateSentence(start: body.lowercased())
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
        
        //100K iterations for training is a lot and can block the main thread so
        Task.detached(priority: .userInitiated) { [weak self] in
            await self?.trainModel()
        }
        
        //sub 50k
      //  trainModel()
    }
    
    //MARK: May need more iterations for more accurate response
    
    private func trainModel() {
        if nlm.loadWeights() { return }
        
        let sequences = [
            ["cat", "sat", "on", "the", "mat", "<end>"],
            ["dog", "ran", "in", "the", "park", "<end>"]
        ]
        
        var pairs: [([String], String)] = []
        for sequence in sequences {
            for i in 1..<sequence.count {
                let context = Array(sequence[0..<i])
                let target = sequence[i]
                pairs.append((context, target))
            }
        }
        
        for _ in 0..<100000 {
            for (context, target) in pairs.shuffled() {
                let targetIndex = nlm.tokens.firstIndex(of: target) ?? 0
                nlm.train(input: context, targetIndex: targetIndex, learningRate: 0.001)
            }
        }
        
        nlm.saveWeights()
        
        //MARK: Test
//        let probs = nlm.forward(["dog", "ran", "on"])
//        print("probs: \(zip(nlm.tokens, probs).map { "\($0.0): \(String(format: "%.3f", $0.1))" })")
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
    
    private func setUpTestData() {
        nlm.tokens = ["cat", "sat", "on", "the", "mat", "dog", "ran", "park", "in", "<end>"]
        nlm.embeddings = [
            "cat":   [1.0, 0.0, 0.0],
            "sat":   [0.0, 1.0, 0.0],
            "on":    [0.0, 0.0, 1.0],
            "the":   [0.5, 0.5, 0.0],
            "mat":   [0.0, 0.5, 0.5],
            "dog":   [0.9, 0.1, 0.2],
            "ran":   [0.1, 0.9, 0.1],
            "park":  [0.2, 0.3, 0.9],
            "in": [0.3, 0.7, 0.4], 
            "<end>": [0.0, 0.0, 0.0]
        ]
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


struct Message : Identifiable {
    var id: Int
    var messageBody : String
    var authourUID : Int
}


