//
//  Modifiers.swift
//  ChatBuddy
//
//  Created by Ethan Hess on 5/12/26.
//

import SwiftUI

@available(iOS 15.0, *)
extension View {
    //MARK: Backgrounds / layers
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
    
    var orangeNeon: some View {
        self.background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.2), .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .lightOrange.withAlphaComponent(0.25)), lineWidth: 1)
        )
    }
    
    var greenNeon: some View {
        self.background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [Color.green.opacity(0.2), .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .lightGreen.withAlphaComponent(0.25)), lineWidth: 1)
        )
    }

    func neon(_ style: NeonStyle) -> some View {
        switch style {
        case .orange:
            AnyView(self.orangeNeon)
        case .green:
            AnyView(self.greenNeon)
        }
    }
}

enum NeonStyle {
    case orange
    case green
}


extension UIColor {
    static let lightOrange = UIColor(red: 255/255, green: 221/255, blue: 86/255, alpha: 1.0)
    static let lightGreen = UIColor(red: 102/255, green: 229/255, blue: 73/255, alpha: 1.0)
}
