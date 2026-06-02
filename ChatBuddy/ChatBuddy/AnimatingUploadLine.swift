//
//  AnimatingUploadLine.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 2/20/26.
//

import SwiftUI


//MARK: Text field + response animation (add progress text)
struct AnimatingUploadLine : View {
    @State private var progress: CGFloat = 0

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.white.opacity(0.5), .blue.opacity(0.5), .cyan.opacity(0.5)]),
            startPoint: .topLeading,
            endPoint: UnitPoint(x: 1 - progress, y: 1 - progress)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                progress = 1
            }
        }.frame(height: 25).cornerRadius(12.5)
    }
}
