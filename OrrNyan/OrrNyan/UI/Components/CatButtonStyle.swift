//
//  CatButtonStyle.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/18.
//

import SwiftUI

struct CatButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, minHeight: 55, maxHeight: 55, alignment: .center)
//                .background(isEnabled ? Color("Purple200") : .white)
                .cornerRadius(16)
                .foregroundColor(isEnabled ? Color.Purple200 : Color.White100)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 0.75)
                        .stroke(isEnabled ? Color.Purple100 : Color.White200))
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)

            configuration.label

                .font(Font.callout)
                .foregroundColor(isEnabled ? Color.Black300 : Color.Black100)
        }
    }
}
