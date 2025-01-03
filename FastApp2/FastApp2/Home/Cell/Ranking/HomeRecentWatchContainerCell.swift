//
//  HomeRecentWatchContainerCell.swift
//  FastAPP2
//
//  Created by PKW on 1/2/25.
//

import UIKit

protocol HomeRecentWatchContainerCellDelegate: AnyObject {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int)
}

class HomeRecentWatchContainerCell: UICollectionViewCell {
    static let identifier: String = "HomeRecentWatchContainerCell"
    static let height: CGFloat = 189
    
    weak var delegate: HomeRecentWatchContainerCellDelegate?
    
    @IBOutlet weak var recentWatchCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.recentWatchCollectionView.layer.cornerRadius = 10
        self.recentWatchCollectionView.layer.borderWidth = 1
        self.recentWatchCollectionView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    
        self.recentWatchCollectionView.register(
            UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier)
        
        self.recentWatchCollectionView.delegate = self
        self.recentWatchCollectionView.dataSource = self
    }
}

extension HomeRecentWatchContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.homeRecentWatchContainerCell(self, didSelectItemAt: indexPath.item)
    }
}

extension HomeRecentWatchContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeRecentWatchItemCell.identifier,
            for: indexPath)
        return cell
    }
}
