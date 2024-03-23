//
//  SoundManager.swift
//  DevOpsPractical5
//
//  Created by Divyesh Vekariya on 23/03/24.
//

import AVFoundation
import AudioToolbox

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let instance = SoundManager()
    private var player: AVAudioPlayer?

    private override init() { }

    func playSound() {
        let soundFileName = "sound"
        if let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp4") ?? Bundle.main.url(forResource: "default_sound", withExtension: "mp3") {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)

                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.delegate = self
                player?.play()
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Error: Audio file '\(soundFileName).mp3' not found.")
        }
    }
    
    func stopSound() {
        player?.stop()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        AudioServicesDisposeSystemSoundID(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
