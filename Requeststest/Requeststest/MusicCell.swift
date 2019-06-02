import UIKit

protocol PlayMusicDelegate {
    func playMusic(_ cell: MusicCell, didPlay music: Data?)
    func stopMusic(_ cell: MusicCell)
}

class MusicCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var itemLoadingBackgroundView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet var playStopButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func playStopButton(_ sender: UIButton) {
        playStopButton.isSelected = !playStopButton.isSelected
        if !playStopButton.isSelected {
            playMusicDelegate?.stopMusic(self)
        } else {
            playMusicDelegate?.playMusic(self, didPlay: music)
        }
    }
    
    // MARK: - Livecycle
    override func prepareForReuse() {
        imageView.image = nil
        musicNameLabel.text = ""
        artistNameLabel.text = ""
        previewUrl = ""
        music = nil
    }
    
    // MARK: - Properties
    static let reuseIdentifier = "musicCell"
    var playMusicDelegate: PlayMusicDelegate?
    var previewUrl: String?
    var music: Data!
    
    // MARK: - Public actions
    func configure(with item: MusicItem) {
        imageView.backgroundColor = .red
        musicNameLabel.text = item.trackName
        artistNameLabel.text = item.artistName
        previewUrl = item.previewUrl
    }
    
    func startIndicator() {
        itemLoadingBackgroundView.isHidden = false
        indicatorView.startAnimating()
    }
    
    func stopIndicator() {
        itemLoadingBackgroundView.isHidden = true
        indicatorView.stopAnimating()
    }
}
