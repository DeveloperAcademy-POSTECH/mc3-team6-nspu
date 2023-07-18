//
//  LottieView.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/18.
//

import SwiftUI
import Lottie
import UIKit

struct LottieView: UIViewRepresentable {

    typealias UIViewType = UIView

    var filename: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        
        animationView.animation = LottieAnimation.named(filename)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // do something
    }
    
}

