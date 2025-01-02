// Created by 박기우
// All rights reserved.

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
}

class HomeRecommendContainerCell: UITableViewCell {
    static let identifier: String = "HomeRecommendContainerCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foldButton: UIButton!

    weak var delegate: HomeRecommendContainerCellDelegate?

    static var height: CGFloat {
        let top: CGFloat = 84 - 6 // 첫번째 cell에서 bottom까지의 거리 - cell의 상단 여백
        let bottom: CGFloat = 68 - 6 // 마지막 cell첫번째 bottom까지의 거리 - cell의 하단 여백
        let footerInset: CGFloat = 51 // container -> footer 까지의 여백
        return HomeRecommendItemCell.height * 5 + top + bottom + footerInset
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        tableView.rowHeight = HomeRecommendItemCell.height
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "HomeRecommendItemCell", bundle: .main),
            forCellReuseIdentifier: HomeRecommendItemCell.identifier
        )
    }

    @IBAction func foldBtnTapped(_: Any) {}
}

extension HomeRecommendContainerCell: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)
    }
}

extension HomeRecommendContainerCell: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: HomeRecommendItemCell.identifier, for: indexPath)
    }
}
