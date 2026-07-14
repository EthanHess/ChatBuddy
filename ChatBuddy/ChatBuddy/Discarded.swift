//
//  Discarded.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 7/7/26.
//




//Discarded code from main NLM class (for reference)

//MARK: Discard after test
//    func combineEmbeddings(_ vectors: Matrix) -> Vector {
//        return vectors.flatMap { $0 }
//    }

//MARK: TODO test + replace with this (the above should not be flat)



//MARK: Potentially add this

//var traverser: FeedTraverser

//MARK: Try this with FT

//    func forward(_ tokens: [String]) -> Vector {
//        let input = combineEmbeddings(embed(input: tokens))
//        return traverser.forward(input)
//    }


//init() {
//    //properties already initialized as empty array but may be time we'd want to pass them in here on init
//    //MARK: Something like below example (try?)
//}





//MARK: Not using atm



//MARK: Handling this already in main NLM class but can maybe use this to make neater / wrap complex logic

//Pass through network foward

//struct FeedTraverser {
//    
//    //MARK: Connects previous and current layers of network, there are input and output layers as well as hidden ones in the middle
//    
//    var layers: [LinearLayer]
//
//    init(layerSizes: [Int]) {
//        //zip merges two sequences (like array for example) into new sequence of tuples
//        self.layers = zip(layerSizes, layerSizes.dropFirst()).map { inputSize, outputSize in
//            LinearLayer(inputSize: inputSize, outputSize: outputSize)
//        }
//    }
//    
//    //MARK: propogation to generate a prediction (all layers)
//    func forward(_ x: [Float]) -> [Float]{
//        return layers.indices.reduce(x) { input, i in
//            let output = layers[i].forward(input)
//            return i < layers.count - 1 ? relu(output) : output  // no ReLU on last layer
//        }
//    }
//
//    //Rectified Linear Unit = ReLU
//    //Will convert a negative number to zero or positive number to itself
//    func relu(_ vec: [Float]) -> [Float] {
//        return vec.map { max(0, $0) }
//    }
//}

