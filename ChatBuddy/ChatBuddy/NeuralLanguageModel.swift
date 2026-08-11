//
//  NewLanguageModel.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 3/10/26.
//

import SwiftUI

//MARK: Newer & updated, more like a real LLM if Swiftfully possible
@Observable
class NeuralLanguageModel {
    typealias Vector = [Float] //Vectors have direction and magnitude in a 3D space
    var embeddings: [String: Vector] = [:] //tokens mapped -> vector
    
    var embeddingSize: Int {
        return embeddings.values.first?.count ?? 0
    }
    
    //tokens (bits of words) that are related are closer in the vector space (like, "hiking", "lake" and "mountains" may be near each other but "computer" is somewhere else, off with "keyboard")
    
    typealias Matrix = [[Float]]
    
    var layers : [LinearLayer] = []
    var tokens : [String] = []
    
    init(layerSizes: [Int]) {
        self.layers = zip(layerSizes, layerSizes.dropFirst()).map { inputSize, outputSize in
            LinearLayer(inputSize: inputSize, outputSize: outputSize)
        }
    }

    func embed(input: [String]) -> Matrix {
        return input.map { token in
            return embeddings[token] != nil ? embeddings[token]! : [Float](repeating: 0, count: embeddingSize)
        }
    }
    
    func combineEmbeddings(_ vectors: Matrix) -> Vector {
        guard !vectors.isEmpty else { return [] }
        let size = vectors[0].count
        var result = [Float](repeating: 0, count: size)
        for vec in vectors {
            for i in 0..<size { result[i] += vec[i] }
        }
        return result.map { $0 / Float(vectors.count) }  //Returns same number no matter how many tokens are passed in, unlike flatMap
    }
    
    //MARK: Replaces the need for FeedTraverser
    func forward(_ tokens: [String]) -> Vector {
        let embeddedTokens = embed(input: tokens)
        let input = combineEmbeddings(embeddedTokens)
        
        var tempInput = input
        
        for (i, layer) in layers.enumerated() {
            tempInput = layer.forward(tempInput)
            
            if i < layers.count - 1 {
                //relu, if positive it stays positive, if negative make positive
                tempInput = relu(tempInput)
            }
        }
        
        return softmax(tempInput)
    }
    
    //MARK: Combine this with other
    func relu(_ vec: Vector) -> Vector {
        return vec.map { max(0, $0) }
    }
    
    //MARK: Vector -> probabilty
    
    //using e (exp) so that bigger values become much bigger when comparing whole array and smaller become much smaller
    func softmax(_ vec: Vector) -> Vector {
        let maxVal = vec.max() ?? 0
        let exps = vec.map { exp($0 - maxVal) }
        let sum = exps.reduce(0, +)
        return exps.map { $0 / sum }
    }
    
    //MARK: Training (the cool part!) (fix ReLU issue of not including numbers clipped to 0)
    //Basically adding ReLU derivitave to backpropogation (the model correcting itself & learning from its mistakes)
    func train(input: [String], targetIndex: Int, learningRate: Float = 0.01) {
        let embedded = combineEmbeddings(embed(input: input))
        var layerInputs = [embedded]
        
        var current = embedded
        for (i, layer) in layers.enumerated() {
            current = layer.forward(current)
            if i < layers.count - 1 {
                current = relu(current)  // match forward's ReLU
            }
            layerInputs.append(current)
        }
        
        let output = softmax(current)
        
        var gradient = output
        gradient[targetIndex] -= 1
        
        for i in stride(from: layers.count - 1, through: 0, by: -1) {
            gradient = layers[i].backward(gradient, input: layerInputs[i], learningRate: learningRate)
            
            // apply ReLU derivative for hidden layers
            if i > 0 {
                gradient = zip(gradient, layerInputs[i]).map { g, x in x > 0 ? g : 0 }
            }
        }
    }
    
    //MARK: Saving / loading training data
    func saveWeights() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(layers) {
            UserDefaults.standard.set(encoded, forKey: "nlm_weights")
            print("Weights saved!")
        }
    }

    func loadWeights() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: "nlm_weights"),
              let decoded = try? JSONDecoder().decode([LinearLayer].self, from: data) else {
            return false
        }
        layers = decoded
        print("Weights loaded!")
        return true
    }
    
    //MARK: TODO add button to clear, training data is bad sometimes
    func resetModel() {
        UserDefaults.standard.removeObject(forKey: "nlm_weights")
    }
}











