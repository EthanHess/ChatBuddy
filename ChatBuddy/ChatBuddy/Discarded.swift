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




//MARK: SLM

//MARK: Put slm top level
//    private func slmTest(_ input: String) -> String  {
//        slm.trainModel(input: input)
//
//        //assume it's a sentence with spaces (add guard to check eventually)
//        guard let firstWord = input
//            .split(whereSeparator: \.isWhitespace)
//            .first.map(String.init) else { return "" }
//        let rep = slm.generateResponse(start: firstWord)
//        return rep
//    }



//    let slm : SmallLanguageModel
//
//    //DI ftw
//    init(slm: SmallLanguageModel) {
//        self.slm = slm
//    }
    


//  @State private var slm = SmallLanguageModel()

//  let languageModel = SmallLanguageModel()
//    _slm = State(initialValue: languageModel)
  //MessageController(slm: languageModel)





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
//    func train(input: [String], targetIndex: Int, learningRate: Float = 0.01) {
//        // forward pass, storing intermediate inputs
//        let embedded = combineEmbeddings(embed(input: input))
//        var layerInputs = [embedded]  // store each layer's input
//
//        var current = embedded
//        for layer in layers {
//            current = layer.forward(current)
//            layerInputs.append(current)
//        }
//
//        let output = softmax(current)
//
//        // gradient of loss
//        var gradient = output
//        gradient[targetIndex] -= 1
//
//        //expensive, comment this out when not needed
//
//        //print("Input: \(input) | Output probs: \(output) | Target: \(targetIndex)")
//
//        // backprop in reverse, passing the correct input for each layer
//        for i in stride(from: layers.count - 1, through: 0, by: -1) {
//            gradient = layers[i].backward(gradient, input: layerInputs[i], learningRate: learningRate)
//        }
//    }
