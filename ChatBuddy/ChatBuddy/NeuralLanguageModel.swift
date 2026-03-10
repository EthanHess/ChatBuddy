//
//  NewLanguageModel.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 3/10/26.
//

import SwiftUI

//MARK: Newer & updated, more like a real LLM if Swiftully possible
@Observable
class NeuralLanguageModel {
    typealias Vector = [Float] //Vectors have direction and magnitude in a 3D space
    var embeddings: [String: Vector] = [:] //tokens mapped -> vector
    
    //tokens (bits of words) that are related are closer in the vector space (like, "hiking", "lake" and "mountains" may be near each other but "computer" is somewhere else, off with "keyboard")
    
    typealias Sequence = [[Float]]
    
    init() {
        
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
}

//Pass through network foward

//Rectified Linear Unit = ReLU
//Will convert a negative number to zero or positive number to itself
struct FeedTraverser {
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
