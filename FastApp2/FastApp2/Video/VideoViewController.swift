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

    // MARK: - 정보 화면

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var channelThumnailImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var recommendTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    private var contentSizeObservation: NSKeyValueObservation?
    private let viewModel = VideoViewModel()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MMdd"

        return formatter
    }()

    private var isControlPannelHidden: Bool = true {
        didSet {
            self.portraitControlPannel.isHidden = self.isControlPannelHidden
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.playerView.delegatet = self

        self.channelThumnailImageView.layer.cornerRadius = 14
        self.setupRecommendTableView()
        self.bindViewModel()
        self.viewModel.request()
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
    }

    @IBAction func fastForwardBtnTapped(_ sender: Any) {
        self.playerView.forward()
    }

    @IBAction func moreBtnTapped(_ sender: Any) {
        let moreVC = MoreViewController()
        self.present(moreVC, animated: false)
    }

    @IBAction func expandBtnTapped(_ sender: Any) {}
}

extension VideoViewController: PlayerViewDeleagte {
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double) {
        self.updatePlayButton(isPlaying: playerView.isPlaying)
    }

    func playerViewReadyToPlay(_ playerView: PlayerView) {}

    func playerViewDidFinishToPlay(_ playerView: PlayerView) {
        self.playerView.seek(to: 0)
        self.updatePlayButton(isPlaying: false)
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
