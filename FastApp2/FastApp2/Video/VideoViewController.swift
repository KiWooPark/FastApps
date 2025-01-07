//
//  VideoViewController.swift
//  FastAPP2
//
//  Created by PKW on 1/7/25.
//

import UIKit

class VideoViewController: UIViewController {
    // MARK: - 제어 화면

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

extension VideoViewController {
    @IBAction func toggleControlPannel(_ sender: Any) {
        self.isControlPannelHidden.toggle()
    }

    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func rewindBtnTapped(_ sender: Any) {}

    @IBAction func playBtnTapped(_ sender: Any) {}

    @IBAction func fastForwardBtnTapped(_ sender: Any) {}

    @IBAction func moreBtnTapped(_ sender: Any) {
        let moreVC = MoreViewController()
        self.present(moreVC, animated: false)
    }

    @IBAction func expandBtnTapped(_ sender: Any) {}
}
