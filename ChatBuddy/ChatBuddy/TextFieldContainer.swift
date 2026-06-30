//
//  TextFieldContainer.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 1/12/26.
//

import SwiftUI

//MARK: TODO make TF look better
struct TextFieldContainer : View {
    @Binding var curText : String
    let messageController: MessageController
    
    var body: some View {
        HStack {
            //TODO make this look nicer
            TextField("Talk to me!", text: $curText)
            Button("Send") {
                messageController.addMessage(curText, authorUID: 0) //add completion / error handling
                curText = ""
            }.padding().blueNeon
        }.padding().edgesIgnoringSafeArea(.all).cornerRadius(10).blueNeon
    }
}
