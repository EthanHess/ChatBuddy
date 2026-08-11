//
//  MessageBubble.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 1/12/26.
//

import SwiftUI

//TODO make this look nicer + add emojis!
struct MessageBubble: View {
    var authorUID : Int
    var messageBody : String
    var body: some View {
        HStack {
            if authorUID == 0 { Spacer() }
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                Text(messageBody)
                    .lineLimit(nil)
            }
            .padding(12)
            .cornerRadius(10)
            .frame(maxWidth: 250, alignment: authorUID == 0 ? .trailing : .leading)
            if authorUID == 1 { Spacer() }
        }.neon(authorUID == 0 ? .green : .orange)
        .padding(.horizontal)
    }
}
