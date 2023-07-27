//
//  AudioManager.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/20.
//

import SwiftUI
import AVFoundation


class AudioManager: ObservableObject {
    
    // singleton
    static var instance = AudioManager()
    private init(){ }
    
    // Audio players
    private var bGMPlayer: AVAudioPlayer?
    private var sFXPlayer: AVAudioPlayer?
    
    // save setting value
    @Published var isBGMEnabled: Bool = UserDefaults.standard.bool(forKey: "BGM"){
        didSet{
            if isBGMEnabled {
                UserDefaults.standard.set(true, forKey: "BGM")
                playBGM()
            } else {
                UserDefaults.standard.set(false, forKey: "BGM")
                stopBGM()
            }
        }
    }
    
    @Published var isSFXEnabled: Bool = UserDefaults.standard.bool(forKey: "SFX") {
        didSet {
            if isSFXEnabled {
                UserDefaults.standard.set(true, forKey: "SFX")
            } else {
                UserDefaults.standard.set(false, forKey: "SFX")
            }
        }
    }
    
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
