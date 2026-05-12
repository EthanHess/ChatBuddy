//
//  Modifiers.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 5/12/26.
//

import SwiftUI

@available(iOS 15.0, *)
extension View {
    var blueNeon: some View {
        self.background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.2), .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.cyan.opacity(0.25), lineWidth: 1)
        )
    }
}
