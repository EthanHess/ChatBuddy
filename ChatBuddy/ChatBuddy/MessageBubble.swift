//
//  MessageBubble.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 1/12/26.
//

import SwiftUI

//TODO make this look nicer
struct MessageBubble: View {
    var authorUID : Int
    var messageBody : String
    var body: some View {
        HStack {
            if authorUID == 0 {
                Spacer()
            }
            HStack {
                Image(systemName: "globe.americas.fill").resizable().scaledToFit().frame(width: 50)
                Text("\(messageBody)")
            }.padding()
            if authorUID == 1 {
                Spacer()
            }
        }.background(
            authorUID == 0 ? .cyan : .green
        ).cornerRadius(10).padding(.horizontal)
    }
}
