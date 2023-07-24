//
//  AudioManager.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/20.
//

import SwiftUI
import AVFoundation


class AudioManager: ObservableObject {
    
    static let instance = AudioManager()
    
    var bGMPlayer: AVAudioPlayer?
    var sFXPlayer: AVAudioPlayer?
    
    @Published var isBGMEnabled: Bool = false
    @Published var isSFXEnabled: Bool = false
    
    
    func toggleBGM(){
        isBGMEnabled.toggle()
    }
    
    func toggleSFX(){
        isSFXEnabled.toggle()
    }
    
    
    func playBGM(fileName: String, fileType: String, isEnabled: Bool){
        guard isBGMEnabled else { return }
        
        playSound(fileName: fileName, fileType: fileType, player: &bGMPlayer, numberOfLoops: -1)
    }
    
    func stopBGM(){
        stopAudio(player: &bGMPlayer)
    }
    
    func playSFX(fileName: String, fileType: String, isEnabled: Bool){
        guard isSFXEnabled else { return }
        
        playSound(fileName: fileName, fileType: fileType, player: &sFXPlayer, numberOfLoops: 0)
    }
    
    private func playSound(fileName: String, fileType: String, player: inout AVAudioPlayer?, numberOfLoops: Int) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else { return }
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = numberOfLoops
            player?.prepareToPlay()
            player?.play()
        } catch let error {
            print("오류가 났다냥. \(error.localizedDescription)")
        }
    }
    
    private func stopAudio(player: inout AVAudioPlayer?){
        player?.stop()
        player = nil
    }
    
    
}
