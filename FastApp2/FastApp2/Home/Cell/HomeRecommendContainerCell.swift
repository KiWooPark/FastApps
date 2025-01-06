// Created by 박기우
// All rights reserved.

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell)
}

class HomeRecommendContainerCell: UICollectionViewCell {
    static let identifier: String = "HomeRecommendContainerCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foldButton: UIButton!

    private var viewModel: HomeRecommendViewModel?
    weak var delegate: HomeRecommendContainerCellDelegate?

    static func height(viewModel: HomeRecommendViewModel) -> CGFloat {
        let top: CGFloat = 84 - 6 // 첫번째 cell에서 bottom까지의 거리 - cell의 상단 여백
        let bottom: CGFloat = 68 - 6 // 마지막 cell첫번째 bottom까지의 거리 - cell의 하단 여백
        return VideoListItemCell.height * CGFloat(viewModel.itemCount) + top + bottom
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        tableView.rowHeight = VideoListItemCell.height
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "VideoListItemCell", bundle: .main),
            forCellReuseIdentifier: VideoListItemCell.identifier
        )
    }

    @IBAction func foldBtnTapped(_: Any) {
        self.viewModel?.toggleFoldState()
        self.delegate?.homeRecommendContainerCellFoldChanged(self)
    }
    
    func setViewModel(_ viewModel: HomeRecommendViewModel) {
        self.viewModel = viewModel
        self.setButtonImage(viewModel.isFolded)
        self.tableView.reloadData() // 아이템 받아와서 새로고침
        
        // 버튼 클로저 등록
        self.viewModel?.foldChanged = { [weak self] isFolded in
            self?.setButtonImage(isFolded)
            self?.tableView.reloadData()
        }
    }
    
    // 이 클래스 내부에서만 사용하므로 private
    private func setButtonImage(_ isFolded: Bool) {
        let imageName: String = isFolded ? "unfold" : "fold"
        self.foldButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

extension HomeRecommendContainerCell: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)
    }
}

extension HomeRecommendContainerCell: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel?.itemCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoListItemCell.identifier, for: indexPath)
        
        if let cell = cell as? VideoListItemCell, let data = self.viewModel?.recommends?[indexPath.item] {
            cell.setData(data, rank: indexPath.row + 1)
        }
        return cell
    }
}
