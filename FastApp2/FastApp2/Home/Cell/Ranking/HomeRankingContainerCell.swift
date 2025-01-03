//
//  HomeRankingContainerCell.swift
//  FastAPP2
//
//  Created by PKW on 1/2/25.
//

import UIKit

protocol HomeRankingContainerCellDelegate: AnyObject {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int)
}

class HomeRankingContainerCell: UICollectionViewCell {
    static let identifier: String = "HomeRankingContainerCell"
    static let height: CGFloat = 265

    weak var delegate: HomeRankingContainerCellDelegate?

    @IBOutlet weak var rankCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.rankCollectionView.register(
            UINib(nibName: HomeRankingItemCell.identifier,
                  bundle: nil),
            forCellWithReuseIdentifier: HomeRankingItemCell.identifier
        )

        self.rankCollectionView.dataSource = self
        self.rankCollectionView.delegate = self
    }
}

extension HomeRankingContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.homeRankingContainerCell(self, didSelectItemAt: indexPath.item)
    }
}

extension HomeRankingContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeRankingItemCell.identifier,
            for: indexPath
        )

        if let cell = cell as? HomeRankingItemCell {
            cell.setRank(indexPath.item + 1)
        }

        return cell
    }
}
