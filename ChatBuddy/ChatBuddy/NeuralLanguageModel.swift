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
    
    init() {
        //properties already initialized as empty array but may be time we'd want to pass them in here on init
    }
    
    func embed(input: [String]) -> Matrix {
        return input.map { token in
            return embeddings[token] != nil ? embeddings[token]! : [Float](repeating: 0, count: embeddingSize)
        }
    }
    
    func combineEmbeddings(_ vectors: Matrix) -> Vector {
        return vectors.flatMap { $0 }
    }
    
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

    //MARK: Weights computation
    func forward(_ x: [Float]) -> [Float] {
        //think of this as weights[x] x bias -> output
        
        return [] //todo imp.
    }
    
    //init with input / output len / size?
}

//Pass through network foward

//Rectified Linear Unit = ReLU
//Will convert a negative number to zero or positive number to itself
struct FeedTraverser {
    
    //Should be array (after test)
    var layerOne: LinearLayer
    var layerTwo: LinearLayer

    func forward(_ x: [Float]) -> [Float] {
        let h = relu(layerOne.forward(x))
        return layerTwo.forward(h)
    }
    
    //2D
    func relu(_ x: Float) -> Float {
        return max(0, x)
    }

    //3D
    func relu(_ vec: [Float]) -> [Float] {
        return vec.map { max(0, $0) }
    }
}
