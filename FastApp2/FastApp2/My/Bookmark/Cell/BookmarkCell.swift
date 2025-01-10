//
//  BookmarkCell.swift
//  FastAPP2
//
//  Created by PKW on 1/9/25.
//

import UIKit

class BookmarkCell: UITableViewCell {
    static let identifier: String = "BookmarkCell"
    
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailImageView.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageTask?.cancel()
        self.imageTask = nil
        
        self.channelNameLabel.text = nil
        self.thumbnailImageView.image = nil
    }
    
    func setData(_ data: Bookmark.Item) {
        self.channelNameLabel.text = data.channel
        self.imageTask = self.thumbnailImageView.loadImage(url: data.thumbnail)
    }
}
