//
//  ContentView.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 1/6/26.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: May want middleman model here, this is a small simple app but tying view directly to data isn't always best option
    
    @Environment(MessageController.self) var messageController
    @State private var curText : String = ""
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                //SV -> LVS more versatile than List in some cases, especially for custom layouts
                //NOTE: lazy lazily loads views but not necessarily data
                ScrollView {
                    LazyVStack {
                        ForEach(messageController.messages) { message in
                            Spacer()
                            MessageBubble(authorUID: message.authourUID, messageBody: message.messageBody).frame(width: geo.size.width * 0.8, height: 100)
                            
                            //MARK: Messages will appear when added but if we ever reload the entire chat may want to paginate (on view appear)
                            
                            Spacer()
                        }
                    }
                }
                Spacer()
                if messageController.isSending == true { AnimatingUploadLine().frame(height: 25) }
                HStack {
                    //TODO make this look nicer
                    TextField("Talk to me!", text: $curText)
                    Button("Send") {
                        messageController.addMessage(curText, authorUID: 0)
                    }
                }.padding().edgesIgnoringSafeArea(.all).background(
                    Color.gray
                ).cornerRadius(10)
                Spacer()
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
