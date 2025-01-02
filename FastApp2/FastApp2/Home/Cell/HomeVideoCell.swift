//
//  HomeVideoCell.swift
//  FastAPP2
//
//  Created by PKW on 12/9/24.
//

import UIKit

class HomeVideoCell: UITableViewCell {
    static let identifire: String = "HomeVideoCell"
    static let height: CGFloat = 321

    @IBOutlet var containerView: UIView!

    @IBOutlet var thumbnailImageView: UIImageView!

    @IBOutlet var hotImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!

    @IBOutlet var channelImageView: UIImageView!
    @IBOutlet var channelTitleLabel: UILabel!
    @IBOutlet var channelSubTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 19
        containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        containerView.layer.borderWidth = 1
    }
}
