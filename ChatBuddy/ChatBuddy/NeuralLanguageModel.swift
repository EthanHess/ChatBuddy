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
    
    
//    func train(input: [String], targetIndex: Int, learningRate: Float = 0.01) {
//        //Forwarding, like to different layers etc. (like from input embeddings through transformer layers)
//        let output = forward(input)
//        
//        //MARK: gradients reduce prediction errors (can be both positive and negative)
//        var outputGradient = output
//        outputGradient[targetIndex] -= 1
//        
//        var gradient = outputGradient
//        for i in stride(from: layers.count - 1, through: 0, by: -1) {
//            gradient = layers[i].backward(gradient, learningRate: learningRate)
//        }
//    }
    
    //MARK: Training (the cool part!)
    func train(input: [String], targetIndex: Int, learningRate: Float = 0.01) {
        // forward pass, storing intermediate inputs
        let embedded = combineEmbeddings(embed(input: input))
        var layerInputs = [embedded]  // store each layer's input
        
        var current = embedded
        for layer in layers {
            current = layer.forward(current)
            layerInputs.append(current)
        }
        
        let output = softmax(current)
        
        // gradient of loss
        var gradient = output
        gradient[targetIndex] -= 1
        
        //expensive, comment this out when not needed
        
        //print("Input: \(input) | Output probs: \(output) | Target: \(targetIndex)")
        
        // backprop in reverse, passing the correct input for each layer
        for i in stride(from: layers.count - 1, through: 0, by: -1) {
            gradient = layers[i].backward(gradient, input: layerInputs[i], learningRate: learningRate)
        }
    }
}











