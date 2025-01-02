//
//  HomeRecommendItemCell.swift
//  FastAPP2
//
//  Created by PKW on 12/20/24.
//

import UIKit

class HomeRecommendItemCell: UITableViewCell {
    static let height: CGFloat = 71
    static let identifier: String = "HomeRecommendItemCell"

    @IBOutlet var thumbnailContainerView: UIView!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    @IBOutlet var playTimeBGView: UIView!
    @IBOutlet var playTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        thumbnailContainerView.layer.cornerRadius = 5
        rankLabel.layer.cornerRadius = 5
        rankLabel.clipsToBounds = true
        playTimeBGView.layer.cornerRadius = 3
    }
}
