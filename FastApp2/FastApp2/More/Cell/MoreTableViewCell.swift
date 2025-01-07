//
//  MoreTableViewCell.swift
//  FastAPP2
//
//  Created by PKW on 1/7/25.
//
import UIKit

class MoreTableViewCell: UITableViewCell {
    static let identifier: String = "MoreTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.descriptionLabel.text = nil
        self.titleLabel.text = nil
    }

    func setItem(_ item: MoreItem, separatorHidden: Bool) {
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.rightText
        self.separatorView.isHidden = separatorHidden
    }
}
