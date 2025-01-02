//
//  HomeRankingItemCell.swift
//  FastAPP2
//
//  Created by PKW on 1/2/25.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {
    static let identifier: String = "HomeRankingItemCell"

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
    }
    
    // 재사용
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.numberLabel.text = nil
    }
    
    func setRank(_ rank: Int) {
        self.numberLabel.text = "\(rank)"
    }
}
