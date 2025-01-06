// Created by 박기우
// All rights reserved.

import UIKit

class HomeVideoCell: UICollectionViewCell {
    static let identifire: String = "HomeVideoCell"
    static let height: CGFloat = 300

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var thumbnailImageView: UIImageView!

    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelSubTitleLabel: UILabel!

    // 테스크 관리
    private var thumbnailTask: Task<Void, Never>?
    private var channelThumbnailTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 19
        containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        containerView.layer.borderWidth = 1
    }
    
    func setData(_ data: Home.Video) {
        
        thumbnailTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
        channelThumbnailTask = self.channelImageView.loadImage(url: data.channelThumbnailURL)
    }
}
