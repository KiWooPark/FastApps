//
//  VideoViewController.swift
//  FastAPP2
//
//  Created by PKW on 1/7/25.
//

import AVKit
import UIKit

protocol VideoViewControllerDelegate: AnyObject {
    // 최소화 시 Y값 얻기
    func videoViewController(_ videoViewController: VideoViewController, yPositionForMinizeView height: CGFloat) -> CGFloat
    // 최소화 상태 알려주기
    func videoViewControllerDidMinimize(_ videoViewController: VideoViewController)
    // 최대화 처리 (비디오 화면 터치 했을때)
    func videoViewControllerNeedsMaximize(_ videoViewController: VideoViewController)
    //
    func videoViewControllerDidTapClose(_ videoViewController: VideoViewController)
}

class VideoViewController: UIViewController {
    
    private let chattingLandscapeConstraint: CGFloat = -500
    
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
    @IBOutlet weak var chattingViewBottomConstraint: NSLayoutConstraint!
    
    // 최소화 뷰
    @IBOutlet weak var minimizePlayerView: PlayerView!
    @IBOutlet weak var minimizeView: UIView!
    @IBOutlet weak var minimizeViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var minimizePlayButton: UIButton!
    @IBOutlet weak var minimizeTitleLabel: UILabel!
    @IBOutlet weak var minimizeChannelLabel: UILabel!
    
    private var contentSizeObservation: NSKeyValueObservation?
    private let viewModel = VideoViewModel()
    
    weak var delegate: VideoViewControllerDelegate?
    
    var isLiveMode: Bool = false
    private var isMinimizeMode: Bool = false {
        didSet {
            self.minimizeView.isHidden = !self.isMinimizeMode
        }
    }
    
    // 실기기에서 테스트해야함
    private var pipController: AVPictureInPictureController?
    
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
        
        self.minimizePlayerView.delegatet = self
        
        self.playerView.delegatet = self
        self.seekBarView.delegate = self
        
        self.chattingView.delegate = self
        
        self.channelThumnailImageView.layer.cornerRadius = 14
        self.setupRecommendTableView()
        self.bindViewModel()
        self.viewModel.request()
        
        self.chattingView.isHidden = !self.isLiveMode
        
        self.setupPIPController()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.switchControlPannel(size: size)
        self.playerViewBottomConstraint.isActive = self.isLandscape(size: size)
        
        self.chattingView.chattingTextField.resignFirstResponder()
        
        if self.isLandscape(size: size) {
            self.chattingViewBottomConstraint.constant = self.chattingLandscapeConstraint
        } else {
            self.chattingViewBottomConstraint.constant = 0
        }
        
        coordinator.animate { _ in
            self.chattingView.chattingCollectionView.collectionViewLayout.invalidateLayout()
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isBeingPresented {
            self.setupPIPController()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isBeingDismissed {
            self.pipController = nil
        }
    }
    
    private func setupPIPController() {
        guard AVPictureInPictureController.isPictureInPictureSupported(),
              let playerLayer = playerView.avPlayerLayer
        else {
            return
        }
        
        let pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        
        self.pipController = pipController
    }
    
    private func isLandscape(size: CGSize) -> Bool {
        return size.width > size.height
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
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
        
        self.minimizeTitleLabel.text = video.title
        self.minimizeChannelLabel.text = video.channel
        
        self.channelThumnailImageView.loadImage(url: video.channelImageUrl)
        self.channelNameLabel.text = video.channel
        self.updateDateLabel.text = Self.dateFormatter.string(from: Date(timeIntervalSince1970: video.uploadTimestamp))
        self.playCountLabel.text = "재생수 \(video.playCount)"
        self.favoriteButton.setTitle("\(video.favoriteCount)", for: .normal)
        self.recommendTableView.reloadData()
    }
}

extension VideoViewController {
    @IBAction func minimizeViewCloseBtnTapped(_ sender: Any) {
        self.delegate?.videoViewControllerDidTapClose(self)
    }
    
    @IBAction func maximize(_ sender: Any) {
        self.delegate?.videoViewControllerNeedsMaximize(self)
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
        self.isMinimizeMode = true
        self.rotateScene(landscape: false)
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
        self.minimizePlayButton.setImage(playImage, for: .normal)
        
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

// 화면전환 커스텀
extension VideoViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}

extension VideoViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.isBeingPresented {
            
            guard let view = transitionContext.view(forKey: .to) else {
                return
            }
            
            transitionContext.containerView.addSubview(view)
            
            if self.isMinimizeMode {
                self.chattingViewBottomConstraint.constant = 0
                self.playerViewBottomConstraint.isActive = false
                self.playerView.isHidden = false
                self.minimizeViewBottomConstraint.isActive = false
                self.isMinimizeMode = false
                
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.frame = .init(
                        origin: .init(x: 0, y: view.safeAreaInsets.top),
                        size: view.window?.frame.size ?? view.frame.size
                    )
                } completion: { _ in
                    view.frame.origin = .zero
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                }
            } else {
                view.alpha = 0
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.alpha = 1
                } completion: { _ in
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                }
            }
        } else {
            guard let view = transitionContext.view(forKey: .from) else {
                return
            }
            
            if self.isMinimizeMode,
               let yPosition = self.delegate?.videoViewController(self, yPositionForMinizeView: self.minimizeView.frame.height) {
                self.minimizePlayerView.player = self.playerView.player
                self.isControlPannelHidden = true
                self.chattingViewBottomConstraint.constant = self.chattingLandscapeConstraint
                self.playerViewBottomConstraint.isActive = true
                self.playerView.isHidden = true
                
                view.frame.origin.y = view.safeAreaInsets.top
                
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.frame.origin.y = yPosition
                    view.frame.size.height = self.minimizeView.frame.height
                } completion: { _ in
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                    self.minimizeViewBottomConstraint.isActive = true
                    self.delegate?.videoViewControllerDidMinimize(self)
                }
            } else {
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.alpha = 0
                } completion: { _ in
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                    view.alpha = 1
                }
            }
        }
    }
}
