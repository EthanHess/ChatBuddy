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
    
    //var traverser: FeedTraverser
    
    //MARK: Try this with FT
    
//    func forward(_ tokens: [String]) -> Vector {
//        let input = combineEmbeddings(embed(input: tokens))
//        return traverser.forward(input)
//    }
    
    var embeddingSize: Int {
        return embeddings.values.first?.count ?? 0
    }
    
    //tokens (bits of words) that are related are closer in the vector space (like, "hiking", "lake" and "mountains" may be near each other but "computer" is somewhere else, off with "keyboard")
    
    typealias Matrix = [[Float]]
    
    var layers : [LinearLayer] = []
    var tokens : [String] = []
    
    init() {
        //properties already initialized as empty array but may be time we'd want to pass them in here on init
        //MARK: Something like below example (try?)
    }
    
//    init(layerSizes: [Int]) {
//        self.layers = zip(layerSizes, layerSizes.dropFirst()).map { inputSize, outputSize in
//            LinearLayer(inputSize: inputSize, outputSize: outputSize)
//        }
//    }
    
    func embed(input: [String]) -> Matrix {
        return input.map { token in
            return embeddings[token] != nil ? embeddings[token]! : [Float](repeating: 0, count: embeddingSize)
        }
    }
    
    //MARK: Discard after test
//    func combineEmbeddings(_ vectors: Matrix) -> Vector {
//        return vectors.flatMap { $0 }
//    }
    
    //MARK: TODO test + replace with this (the above should not be flat)
    
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
}

//Weights = strength in which each input affects output
//Bias related to weights (assists them)

//MARK: Put weights and functionality here
struct LinearLayer {
    var weights: [[Float]]  //output X input
    var bias: [Float]      // just output, kind of a helper

    //MARK: Weights computation (handles this layer)
    func forward(_ x: [Float]) -> [Float] {
        //think of this as weights[x] x bias -> output
        
        return weights.indices.map { i in
            //zip = Creates a sequence of pairs built out of two underlying sequences (like two arrays in this case)
            let dot = zip(weights[i], x).reduce(0) { $0 + $1.0 * $1.1 }
            return dot + bias[i] //add to bias at index
        }
    }
    
    //init with input / output len / size?
    init(inputSize: Int, outputSize: Int) {
        let scale = sqrt(2.0 / Float(inputSize))
        
        self.weights = (0..<outputSize).map { _ in
            (0..<inputSize).map { _ in Float.random(in: -scale...scale) } //init weights with random values
        }
        self.bias = [Float](repeating: 0, count: outputSize) //repeating fills array with 0 (or whatever val)
    }
}


//MARK: Handling this already in main NLM class but can maybe use this to make neater / wrap complex logic

//Pass through network foward
struct FeedTraverser {
    
    //MARK: Connects previous and current layers of network, there are input and output layers as well as hidden ones in the middle
    
    var layers: [LinearLayer]

    init(layerSizes: [Int]) {
        //zip merges two sequences (like array for example) into new sequence of tuples
        self.layers = zip(layerSizes, layerSizes.dropFirst()).map { inputSize, outputSize in
            LinearLayer(inputSize: inputSize, outputSize: outputSize)
        }
    }
    
    //MARK: propogation to generate a prediction (all layers)
    func forward(_ x: [Float]) -> [Float]{
        return layers.indices.reduce(x) { input, i in
            let output = layers[i].forward(input)
            return i < layers.count - 1 ? relu(output) : output  // no ReLU on last layer
        }
    }

    //Rectified Linear Unit = ReLU
    //Will convert a negative number to zero or positive number to itself
    func relu(_ vec: [Float]) -> [Float] {
        return vec.map { max(0, $0) }
    }
}
