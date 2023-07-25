//
//  AudioManager.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/20.
//

import SwiftUI
import AVFoundation


class AudioManager: ObservableObject {
    
    static var instance = AudioManager()
    
    private init(){ }
    
    // Audio players
    var bGMPlayer: AVAudioPlayer?
    var sFXPlayer: AVAudioPlayer?
    
    // save setting value
    @AppStorage("BGM") var isBGMEnabled = false
    @AppStorage("SFX") var isSFXEnabled = false

    
    func playBGM(){
        playSound(fileName: "TestBGM", fileType: "mp3", player: &bGMPlayer, numberOfLoops: -1)
    }
    
    func stopBGM(){
        stopAudio(player: &bGMPlayer)
    }
    
    func playSFX(fileName: String, fileType: String){
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
