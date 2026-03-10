//
//  SmallLanguageModel.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 1/6/26.
//

import SwiftUI

//MARK: TODO relations + store on device for future memory

//MARK: Similar to autocomplete algorithm but way more complex, dynamic and with more context
@Observable
class SmallLanguageModel {
    //Count frequency of words connected to current word
    //Example [Hello: [how: 3, what: 1]]
    
    //Example of weights would be numbers here
    
    //This is currently a Markov chain style predictor (super simple
    var slmDict: [String: [String: Int]] = [:]
    
    //Train model with word frequencies + connections
    func trainModel(input: String) {
        let words = input.lowercased().components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        guard words.count > 1 else { return }
        
        //placeholders to teach model sentence ordering
        let tokens = ["<start>", "<start>"] + words

        for i in 0..<tokens.count - 2 {
            let key = "\(tokens[i]) \(tokens[i + 1])"
            let next = tokens[i + 2]
            slmDict[key, default: [:]][next, default: 0] += 1
        }
    }
    
    //MARK: ^^ Trigram = predicts next words based on two current ones instead of one, increasing accuracy
    
    //Temperature = Randomness of next word, may choose word with not much frequency and be weird / make no sense :)
    
    //Weights = related to temperature but temperature changes how weights are used (not the same thing). Weights represent learned probabilities.
    
    //Attention = context focus happening inside transformer (like, knowing the context of "it" in a sentence)
    
    //LLM = Attention + Transformer (which is when tokens get imbedded into a numerical neural network)
    
    //Real LLMs break words into subtokens for lower memory footprint + fewer words stored
    
    
    //Pick a word to start from iterate through possibilities based on candidates (potential words to add to sentence)
    func generateResponse(start: String) -> String {
        let length = 20
        let temperature = 0.8

        //placeholder for sentence ordering
        var wordOne = "<start>"
        var wordTwo = start.lowercased()

        var result = [wordTwo]

        for _ in 0..<length {
            let key = "\(wordOne) \(wordTwo)"

            guard let nextCandidates = slmDict[key] else { break }
            
            //Controls temperature
            let adjusted = nextCandidates.mapValues {
                pow(Double($0), 1.0 / temperature)
            }
            
            let total = adjusted.values.reduce(0, +) //This combines all into one, the (0, +) part
            let rand = Double.random(in: 0..<total)
            
            var cumulative = 0.0
            var chosen: String?

            for (word, weight) in adjusted {
                cumulative += weight
                if rand < cumulative {
                    chosen = word
                    break
                }
            }
            
            guard let next = chosen else { break }

            result.append(next)
            wordOne = wordTwo
            wordTwo = next
        }

        return result.joined(separator: " ")
    }
}
