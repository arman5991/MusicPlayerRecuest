import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchIndicator: UIActivityIndicatorView!
    @IBOutlet var searchLoadingBackgroundView: UIView!
    
    // MARK: - Properties
    private var musicViewModels: [MusicViewModel] = []
    private let musicPlayer = MusicPlayer.instance
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }

    // MARK: - Private functions
    private func initViews() {
        searchBar.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let itemSize = (self.view.bounds.width - 2) / 2
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
    }
    
    private func searchMusic(with term: String) {
        RequestManager.getSongsByArtistName(term, completion: { (musics) in
            var viewModels: [MusicViewModel] = []
            for item in musics {
                viewModels.append(MusicViewModel(musicItem: item))
            }
            self.musicViewModels = viewModels
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.stopIndicator()
            }
        }) { (error) in
            print(error)
        }
    }
    
    func startIndicator() {
        searchLoadingBackgroundView.backgroundColor = .lightGray
        searchLoadingBackgroundView.isHidden = false
        searchIndicator.startAnimating()
    }
    
    func stopIndicator() {
        searchLoadingBackgroundView.isHidden = true
        searchIndicator.stopAnimating()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCell.reuseIdentifier, for: indexPath) as? MusicCell else {
            return MusicCell()
        }
        item.tag = indexPath.row
        let viewModel = musicViewModels[indexPath.row]
        item.playMusicDelegate = self
        item.configure(with: viewModel.musicItem)
        item.startIndicator()
        viewModel.downloadImage { (image) in
            if item.music != nil {
                item.stopIndicator()
            }
            item.imageView.image = image
        }
        
        viewModel.downloadMusic { (music) in
            item.music = music
            if item.imageView.image != nil {
                item.stopIndicator()
            }
        }
        return item
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if let term = searchBar.text {
            startIndicator()
            searchMusic(with: term)
            deselectPreviewPlayOrStopButton()
            musicPlayer.stop()
        }
    }
}

extension ViewController: PlayMusicDelegate {
    func playMusic(_ cell: MusicCell, didPlay music: Data?) {
        if selectedIndexPath != IndexPath(item: cell.tag, section: 0) {
            deselectPreviewPlayOrStopButton()
        }
        selectedIndexPath = IndexPath(item: cell.tag, section: 0)
        musicPlayer.play(music: music)
    }
    
    func stopMusic(_ cell: MusicCell) {
        deselectPreviewPlayOrStopButton()
        selectedIndexPath = nil
        musicPlayer.stop()
    }
    
    private func deselectPreviewPlayOrStopButton() {
        if let selectedIndexPath = selectedIndexPath, let previewCell = collectionView.cellForItem(at: selectedIndexPath) as? MusicCell {
            previewCell.playStopButton.isSelected = false
        }
    }
}

