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



//MARK: Pre context

//private func generateSentence(start: String, maxLength: Int = 5) -> String {
//    var result = [start]
//    var currentToken = start
//    
////        for _ in 0..<maxLength {
////            //MARK: Debugging, remove when finished
////            let probs = nlm.forward([currentToken])
////            print("\(currentToken) probs: \(zip(nlm.tokens, probs).map { "\($0.0): \(String(format: "%.3f", $0.1))" })")
////
////            let nextToken = nlmTest(currentToken)
////            if nextToken == "<end>" { break }
////            if nextToken == currentToken { break } //need to stop at some point or this'll go forever
////            result.append(nextToken)
////            currentToken = nextToken
////        }
//    
//    var visited = Set<String>()
//    
//    for _ in 0..<maxLength {
//        let nextToken = nlmTest(currentToken)
//        if nextToken == "<end>" { break }
//        if visited.contains(nextToken) { break }  // catches cycles
//        visited.insert(nextToken)
//        result.append(nextToken)
//        currentToken = nextToken
//    }
//   
//    return result.joined(separator: " ")
//}



//private func nlmTest(_ input: String) -> String  {
//    //[String]
//    let tokens = input.split(whereSeparator: \.isWhitespace).map(String.init)
//    //returning Vector (which is [Float])
//    let probabilities = nlm.forward(tokens)
//    
//    //highest propbability (token)
//    guard let maxIndex = probabilities.indices.max(by: { probabilities[$0] < probabilities[$1] }) else { return "" }
//    return nlm.tokens[maxIndex]
//}


//let res = slmTest(body)
//        let res = "OMG Hey what's up n00b I'm a chatbot"
// let res = nlmTest(body)




//MARK: Old add message

//        if isSending == true { return }
//        isSending = true
//        let message = Message(id: messages.count, messageBody: body, authourUID: authorUID)
//        messages.append(message)

//
//DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
//    guard let self = self else { return }
//    let res = generateSentence(start: body.lowercased())
//    let resMessage = Message(id: messages.count, messageBody: res, authourUID: 1)
//    messages.append(resMessage)
//    isSending = false
//}


//   // var messages : [Message] = []



//Old app entry

//@main
//struct ChatBuddyApp: App {
//    
//    //MARK: Top level / App entry point, most shared objects (environment etc.) should go here to not be nested too deep unless there's a good reason
//    
//    //Also won't be created multiple times
//    
//    //MARK: layers = processing steps in an llm
//    
//    //MARK: 6 = input size (only with flat map, aside from that it would be 3), 4 = hidden layer -> 4 neurons (numbers in this case) 6 down (embedding size), 3 = output size, in this case the "cat" token
//    
//    //MARK: TODO test with [3, 4, 3]
//    @State private var messageController : MessageController
//    @State private var nlm = NeuralLanguageModel(layerSizes: [3, 8, 10])
//    
//    init() {
//        
//        let languageModel = NeuralLanguageModel(layerSizes: [3, 8, 10])
//        _nlm = State(initialValue: languageModel)
//
//        _messageController = State(initialValue: MessageController(nlm: languageModel))
//    }
//    
//    var body: some Scene {
//        WindowGroup {
////            ContentView().environment(nlm)
////                .environment(messageController)
//            
//            ChatsTable().environment(messageController)
//        }
//    }
//}
//




//From MessageController (old traning code)

//MARK: May need more iterations for more accurate response

//private func trainModel() {
//    if nlm.loadWeights() { return }
//    
//    let sequences = [
//        ["cat", "sat", "on", "the", "mat", "<end>"],
//        ["dog", "ran", "in", "the", "park", "<end>"],
//        ["cat", "ran", "in", "the", "park", "<end>"],
//        ["dog", "sat", "on", "the", "mat", "<end>"]
//    ]
//    
//    var pairs: [([String], String)] = []
//    for sequence in sequences {
//        for i in 1..<sequence.count {
//            let context = Array(sequence[0..<i])
//            let target = sequence[i]
//            pairs.append((context, target))
//        }
//    }
//    
//    for _ in 0..<100000 {
//        for (context, target) in pairs.shuffled() {
//            let targetIndex = nlm.tokens.firstIndex(of: target) ?? 0
//            nlm.train(input: context, targetIndex: targetIndex, learningRate: 0.001)
//        }
//    }
//    
//    nlm.saveWeights()
//    
//    //MARK: Test
////        let probs = nlm.forward(["dog", "ran", "on"])
////        print("probs: \(zip(nlm.tokens, probs).map { "\($0.0): \(String(format: "%.3f", $0.1))" })")
//}


//MARK: Now doing this and train() in NLM
//private func setUpTestData() {
//    nlm.tokens = ["cat", "sat", "on", "the", "mat", "dog", "ran", "park", "in", "<end>"]
//    nlm.embeddings = [
//        "cat":   [1.0, 0.0, 0.0],
//        "sat":   [0.0, 1.0, 0.0],
//        "on":    [0.0, 0.0, 1.0],
//        "the":   [0.5, 0.5, 0.0],
//        "mat":   [0.0, 0.5, 0.5],
//        "dog":   [0.9, 0.1, 0.2],
//        "ran":   [0.1, 0.9, 0.1],
//        "park":  [0.2, 0.3, 0.9],
//        "in": [0.3, 0.7, 0.4],
//        "<end>": [0.0, 0.0, 0.0]
//    ]
//}
