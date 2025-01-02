// Created by 박기우
// All rights reserved.

import UIKit

class HomeRecommendItemCell: UITableViewCell {
    static let height: CGFloat = 71
    static let identifier: String = "HomeRecommendItemCell"

    @IBOutlet weak var thumbnailContainerView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    @IBOutlet weak var playTimeBGView: UIView!
    @IBOutlet weak var playTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        thumbnailContainerView.layer.cornerRadius = 5
        rankLabel.layer.cornerRadius = 5
        rankLabel.clipsToBounds = true
        playTimeBGView.layer.cornerRadius = 3
    }
}
