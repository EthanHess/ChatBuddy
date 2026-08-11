//
//  LinearLayer.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 7/14/26.
//

import SwiftUI


//Weights = strength in which each input affects output
//Bias related to weights (assists them)

//MARK: Put weights and functionality here

//MARK: Codable to save training data (weights etc.)
struct LinearLayer : Codable  {
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
    
    
    //learning rate = weight adjustments
    mutating func backward(_ gradient: [Float], input: [Float], learningRate: Float) -> [Float] {
        //Prev. layer
        var inputGradient = [Float](repeating: 0, count: weights[0].count)
        
        for i in weights.indices {
            for j in weights[i].indices {
                //neuron row (weights) (reducing error is what this is doing)
                weights[i][j] -= learningRate * gradient[i] * input[j]
            }
            bias[i] -= learningRate * gradient[i]
                    
            //signaling previous layer
            for j in inputGradient.indices {
                inputGradient[j] += gradient[i] * weights[i][j]
            }
        }
        
        return inputGradient
    }
}
