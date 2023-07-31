//
//  LottieViewWatch.swift
//  OrrNyan Watch App
//
//  Created by Park Jisoo on 2023/07/31.
//

import SwiftUI
import UIKit
import SDWebImageLottieCoder


class LottieViewWatch: ObservableObject {
    @Published private(set) var image: UIImage = UIImage(named: "upCat")!
    
    private var coder: SDImageLottieCoder?
    private var animationTimer: Timer?
    private var currentFrame: UInt = 0
    private var playing: Bool = false
    private var speed: Double = 1.0
    
    
    func loadAnimation(url: URL) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.setupAnimation(with: data)
            }
        }
        dataTask.resume()
    }
    
    
    func loadAnimationFromFile(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        DispatchQueue.main.async {
            self.setupAnimation(with: data)
        }
    }
    
    private func setupAnimation(with data: Data) {
        coder = SDImageLottieCoder(animatedImageData: data, options: [SDImageCoderOption.decodeLottieResourcePath: Bundle.main.resourcePath!])
        
        currentFrame = 0
        setImage(frame: currentFrame)
        
        play()
    }
    
    private func setImage(frame: UInt) {
        guard let coder = coder,
              let uiImage = coder.animatedImageFrame(at: frame) else { return }
        self.image = uiImage
    }
    
    private func nextFrame() {
        guard let coder = coder else { return }
        
        currentFrame += 1
        if currentFrame >= coder.animatedImageFrameCount {
            currentFrame = 0
        }
        setImage(frame: currentFrame)
    }
    
    
    private func play() {
        playing = true
        
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05/speed, repeats: true, block: { (timer) in
            guard self.playing else {
                timer.invalidate()
                return
            }
            self.nextFrame()
        })
    }
    
    private func pause() {
        playing = true
        animationTimer?.invalidate()
    }
    
    
}

