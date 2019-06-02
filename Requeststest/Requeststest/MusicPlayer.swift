import Foundation
import AVFoundation

class MusicPlayer {
    
    static var instance = MusicPlayer()
    
    private init() {}
    private var player: AVAudioPlayer?
    
    func play(music: Data?) {
        do {
            if let music = music {
                player = try AVAudioPlayer(data: music)
                player?.play()
            }
        } catch let error {
            print(error)
        }
    }
    
    func stop() {
        player?.stop()
    }
}
