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
        ZStack{
            Rectangle()
                .frame(height: 50)
                .cornerRadius(5)
                .foregroundColor(isEnabled ? .blue : .gray)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            
            configuration.label
              
                .font(Font.callout)
                .foregroundColor(isEnabled ? .white : .black)
            
        }
    }
}
