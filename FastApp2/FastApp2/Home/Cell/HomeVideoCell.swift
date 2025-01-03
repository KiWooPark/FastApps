// Created by 박기우
// All rights reserved.

import UIKit

class HomeVideoCell: UICollectionViewCell {
    static let identifire: String = "HomeVideoCell"
    static let height: CGFloat = 321

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var thumbnailImageView: UIImageView!

    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelSubTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 19
        containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        containerView.layer.borderWidth = 1
    }
}
