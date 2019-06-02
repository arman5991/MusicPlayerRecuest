import UIKit

class MusicViewModel {
    
    let musicItem: MusicItem!
    let musicPlayer = MusicPlayer.instance
    var image: UIImage?
    var music: Data!
    
    init(musicItem: MusicItem) {
        self.musicItem = musicItem
    }
    
    func downloadImage(completion: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.global().async {
            if let image = self.image {
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            guard let url = URL(string: self.musicItem.artworkUrl100) else { return }
            do {
                let img =  try UIImage(data: Data(contentsOf: url))
                self.image = img
                DispatchQueue.main.async {
                    completion(img!)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func downloadMusic(completion: @escaping (_ music: Data) -> ()) {
        DispatchQueue.global().async {
            if let music = self.music {
                DispatchQueue.main.async {
                    completion(music)
                }
                return
            }
            guard let url = URL(string: self.musicItem.previewUrl) else { return }
            do {
                let track =  try Data(contentsOf: url)
                self.music = track
                DispatchQueue.main.async {
                    completion(track)
                }
            } catch let error {
                print(error)
            }
        }
    }
}
