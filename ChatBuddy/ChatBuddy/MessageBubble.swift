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
            if authorUID == 0 { Spacer() }
            HStack(spacing: 10) {
                Image(systemName: "globe.americas.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                Text(messageBody)
                    .lineLimit(nil)
            }
            .padding(12)
            .background(authorUID == 0 ? Color.cyan : Color.green)
            .cornerRadius(10)
            .frame(maxWidth: 250, alignment: authorUID == 0 ? .trailing : .leading)
            if authorUID == 1 { Spacer() }
        }
        .padding(.horizontal)
    }
}
