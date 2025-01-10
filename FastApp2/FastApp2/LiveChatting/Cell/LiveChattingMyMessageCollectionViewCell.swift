//
//  LiveChattingMyMessageCollectionViewCell.swift
//  FastAPP2
//
//  Created by PKW on 1/10/25.
//

import UIKit

class LiveChattingMyMessageCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "LiveChattingMyMessageCollectionViewCell"
    
    // 텍스트 크기 계산을 위한 임시 셀
    private static let sizingCell = Bundle.main.loadNibNamed(
        identifier,
        owner: nil)?.first(where: { message in
        message is LiveChattingMyMessageCollectionViewCell
    }) as? LiveChattingMyMessageCollectionViewCell
    
    // 오토레이아웃 엔진을 사용하는 방법은 비용이 비싸기 때문에 추후에 복잡한 레이아웃이라면
    // 다른 방법으로 적용해야함
    static func size(width: CGFloat, text: String) -> CGSize {
        Self.sizingCell?.setText(text)
        Self.sizingCell?.frame.size.width = width
        
        let fittingSize = Self.sizingCell?.systemLayoutSizeFitting(
            .init(width: width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return fittingSize ?? .zero
    }
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgView.layer.cornerRadius = 8
    }
    
    func setText(_ text: String) {
        self.textLabel.text = text
    }
}
