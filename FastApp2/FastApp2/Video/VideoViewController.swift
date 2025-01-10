//
//  VideoViewController.swift
//  FastAPP2
//
//  Created by PKW on 1/7/25.
//

import UIKit

class VideoViewController: UIViewController {
    // MARK: - 제어 화면

    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var portraitControlPannel: UIView!
    @IBOutlet weak var landscapeControlPannel: UIView!
    
    @IBOutlet weak var seekBarView: SeekbarView!
    // MARK: - 정보 화면

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var channelThumnailImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var recommendTableView: UITableView!
    
    @IBOutlet weak var landscapeTitleLabel: UILabel!
    @IBOutlet weak var landscapePlayButton: UIButton!
    @IBOutlet weak var landscapePlayTimeLabel: UILabel!
    
    @IBOutlet weak var chattingView: ChattingView!
    
    @IBOutlet var playerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    private var contentSizeObservation: NSKeyValueObservation?
    private let viewModel = VideoViewModel()
    
    var isLiveMode: Bool = false

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MMdd"

        return formatter
    }()

    private var isControlPannelHidden: Bool = true {
        didSet {
            if self.isLandscape(size: self.view.frame.size) {
                self.landscapeControlPannel.isHidden = self.isControlPannelHidden
            } else {
                self.portraitControlPannel.isHidden = self.isControlPannelHidden
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.playerView.delegatet = self
        self.seekBarView.delegate = self
        
        self.chattingView.delegate = self

        self.channelThumnailImageView.layer.cornerRadius = 14
        self.setupRecommendTableView()
        self.bindViewModel()
        self.viewModel.request()
        
        self.chattingView.isHidden = !self.isLiveMode
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.switchControlPannel(size: size)
        self.playerViewBottomConstraint.isActive = self.isLandscape(size: size)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func isLandscape(size: CGSize) -> Bool {
        return size.width > size.height
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.modalPresentationStyle = .fullScreen
    }

    private func bindViewModel() {
        self.viewModel.dataChangeHandler = { [weak self] video in
            self?.setupData(video)
        }
    }

    private func setupData(_ video: Video) {
        self.playerView.setVideo(url: video.videoURL)
        self.playerView.play()

        self.titleLabel.text = video.title
        self.landscapeTitleLabel.text = video.title
        
        self.channelThumnailImageView.loadImage(url: video.channelImageUrl)
        self.channelNameLabel.text = video.channel
        self.updateDateLabel.text = Self.dateFormatter.string(from: Date(timeIntervalSince1970: video.uploadTimestamp))
        self.playCountLabel.text = "재생수 \(video.playCount)"
        self.favoriteButton.setTitle("\(video.favoriteCount)", for: .normal)
        self.recommendTableView.reloadData()
    }
}

extension VideoViewController {
    private func setupRecommendTableView() {
        self.recommendTableView.delegate = self
        self.recommendTableView.dataSource = self
        self.recommendTableView.rowHeight = VideoListItemCell.height
        self.recommendTableView.register(
            UINib(nibName: VideoListItemCell.identifier, bundle: nil),
            forCellReuseIdentifier: VideoListItemCell.identifier
        )

        self.contentSizeObservation = self.recommendTableView.observe(
            \.contentSize,
            changeHandler: { [weak self] tableView, _ in
                self?.tableViewHeightConstraint.constant = tableView.contentSize.height
            }
        )
    }
}

extension VideoViewController {
    
    private func switchControlPannel(size: CGSize) {
        guard self.isControlPannelHidden == false else {
            return
        }
        
        self.landscapeControlPannel.isHidden = !self.isLandscape(size: size)
        self.portraitControlPannel.isHidden = self.isLandscape(size: size)
    }
    
    @IBAction func toggleControlPannel(_ sender: Any) {
        self.isControlPannelHidden.toggle()
    }

    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func rewindBtnTapped(_ sender: Any) {
        self.playerView.rewind()
    }

    @IBAction func playBtnTapped(_ sender: Any) {
        if self.playerView.isPlaying {
            self.playerView.pause()
        } else {
            self.playerView.play()
        }

        self.updatePlayButton(isPlaying: self.playerView.isPlaying)
    }

    // 재생 상황에 따라 플레이 버튼 변경
    private func updatePlayButton(isPlaying: Bool) {
        let playImage = isPlaying ? UIImage(named: "small_pause") : UIImage(named: "small_play")
        self.playButton.setImage(playImage, for: .normal)
        
        let landscapePlayImage = isPlaying ? UIImage(named: "big_pause") : UIImage(named: "big_play")
        self.landscapePlayButton.setImage(landscapePlayImage, for: .normal)
    }

    @IBAction func fastForwardBtnTapped(_ sender: Any) {
        self.playerView.forward()
    }

    @IBAction func moreBtnTapped(_ sender: Any) {
        let moreVC = MoreViewController()
        self.present(moreVC, animated: false)
    }

    @IBAction func expandBtnTapped(_ sender: Any) {
        self.rotateScene(landscape: true)
    }
    
    @IBAction func shrinkDidTap(_ sender: Any) {
        self.rotateScene(landscape: false)
    }
    
    @IBAction func commentDidTap(_ sender: Any) {
        if self.isLiveMode {
            self.chattingView.isHidden = false
        }
    }
    
    private func rotateScene(landscape: Bool) {
        if #available(iOS 16.0, *) {
            self.view.window?.windowScene?.requestGeometryUpdate(
                .iOS(interfaceOrientations: landscape ? .landscapeRight : .portrait)
            )
        } else {
            // 과거 가로 세로 전환 방법
            let orientation: UIInterfaceOrientation = landscape ? .landscapeRight : .portrait
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

extension VideoViewController: PlayerViewDeleagte {
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double) {
        self.seekBarView.setPlayTime(playTime, playableTime: playableTime)
        self.updatePlayTime(playTime, totalPlayTime: playerView.totalPlayTime)
    }

    func playerViewReadyToPlay(_ playerView: PlayerView) {
        self.seekBarView.setTotalPlayTime(self.playerView.totalPlayTime)
        self.updatePlayButton(isPlaying: playerView.isPlaying)
        self.updatePlayTime(0, totalPlayTime: playerView.totalPlayTime)
    }

    func playerViewDidFinishToPlay(_ playerView: PlayerView) {
        self.playerView.seek(to: 0)
        self.updatePlayButton(isPlaying: false)
    }
    
    private func updatePlayTime(_ playTime: Double, totalPlayTime: Double) {
        guard
            let playTimeText = DateComponentsFormatter.playTimeFormatter.string(from: playTime),
            let totalPlayTimeText = DateComponentsFormatter.playTimeFormatter.string(from: totalPlayTime)
        else {
            self.landscapePlayTimeLabel.text = nil
            return
        }
        
        self.landscapePlayTimeLabel.text = "\(playTimeText) / \(totalPlayTimeText)"
    }
}

extension VideoViewController: SeekbarViewDelegate {
    func seekbar(_ seekbar: SeekbarView, seekToPercent percent: Double) {
        self.playerView.seek(to: percent)
    }
}

extension VideoViewController: UITableViewDelegate {}

extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.video?.recommends.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoListItemCell.identifier, for: indexPath)

        if let cell = cell as? VideoListItemCell,
           let data = self.viewModel.video?.recommends[indexPath.row]
        {
            cell.setData(data, rank: indexPath.row + 1)
        }

        return cell
    }
}

extension VideoViewController: ChattingViewDeleagte {
    func liveChattingViewCloseTapped(_ chattingView: ChattingView) {
        self.chattingView.isHidden = true
        
    }
}
