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
        GeometryReader { geo in //We can remove this and just add frame(.infinity) since SwiftUI sizes well 
            VStack {
                HStack {
                    Button("Clear model") {
                        messageController.clearData()
                    }.padding().redNeon.foregroundStyle(.red)
                    Button("Print") {
                        messageController.printTest()
                    }.padding().redNeon.foregroundStyle(.red)
                }.padding()
                Spacer()
                //SV -> LVS more versatile than List in some cases, especially for custom layouts
                //NOTE: lazy lazily loads views but not necessarily data
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(messageController.messages) { message in
                                Spacer()
                                MessageBubble(authorUID: message.authourUID, messageBody: message.messageBody).frame(width: geo.size.width * 0.8, height: 100)
                                
                                //MARK: Messages will appear when added but if we ever reload the entire chat may want to paginate (on view appear)
                                
                                Spacer()
                            }
                        }
                    }.onChange(of: messageController.messages.count) { oldValue, newValue in
                        guard let last = messageController.messages.indices.last else { return }
                        withAnimation {
                            //Needs to scroll a bit lower
                            proxy.scrollTo(last, anchor: .bottom)
                        }
                    }
                }
                Spacer()
                if messageController.isSending { AnimatingUploadLine().frame(height: 25) }
                TextFieldContainer(curText: $curText, messageController: messageController)
                Spacer()
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
