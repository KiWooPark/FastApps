// Created by 박기우
// All rights reserved.

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var videoTableView: UITableView!
    private let homeViewModel: HomeViewModel = .init()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupVideoTableView()
    }

    func setupVideoTableView() {
        // 헤더뷰 셀 추가
        videoTableView.register(
            UINib(
                nibName: HomeHeaderCell.identifier,
                bundle: nil
            ),
            forCellReuseIdentifier: HomeHeaderCell.identifier
        )

        // 비디오 셀 추가
        videoTableView.register(
            UINib(
                nibName: HomeVideoCell.identifire,
                bundle: nil
            ),
            forCellReuseIdentifier: HomeVideoCell.identifire
        )

        // 추천 셀 추가
        videoTableView.register(
            UINib(
                nibName: HomeRecommendContainerCell.identifier,
                bundle: nil
            ),
            forCellReuseIdentifier: HomeRecommendContainerCell.identifier
        )

        // 랭킹 셀 추가
        videoTableView.register(
            UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRankingContainerCell.identifier
        )
        
        // 최근 시청 셀 추가
        videoTableView.register(
            UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecentWatchContainerCell.identifier)

        // 푸터뷰 셀 추가
        videoTableView.register(
            UINib(
                nibName: HomeFooterCell.identifier,
                bundle: nil
            ),
            forCellReuseIdentifier: HomeFooterCell.identifier
        )

        // 빈 셀 추가
        videoTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "empty"
        )

        videoTableView.delegate = self
        videoTableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return 0
        }

        switch section {
        case .header:
            return HomeHeaderCell.height
        case .video:
            return HomeVideoCell.height
        case .ranking:
            return HomeRankingContainerCell.height
        case .recentWatch:
            return HomeRecentWatchContainerCell.height
        case .recommend:
            return HomeRecommendContainerCell.height
        case .footer:
            return HomeFooterCell.height
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return HomeSection.allCases.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else {
            return 0
        }

        switch section {
        case .header:
            return 1
        case .video:
            return 2
        case .ranking:
            return 1
        case .recentWatch:
            return 1
        case .recommend:
            return 1
        case .footer:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return tableView.dequeueReusableCell(
                withIdentifier: "empty",
                for: indexPath
            )
        }

        switch section {
        case .header:
            return tableView.dequeueReusableCell(withIdentifier: HomeHeaderCell.identifier, for: indexPath)
        case .video:
            return tableView.dequeueReusableCell(withIdentifier: HomeVideoCell.identifire, for: indexPath)
        case .ranking:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRankingContainerCell.identifier, for: indexPath)

            (cell as? HomeRankingContainerCell)?.delegate = self

            return cell
        case .recentWatch:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecentWatchContainerCell.identifier, for: indexPath)
            
            (cell as? HomeRecentWatchContainerCell)?.delegate = self
            
            return cell
        case .recommend:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendContainerCell.identifier, for: indexPath)
            
            (cell as? HomeRecommendContainerCell)?.delegate = self
            
            return cell
        case .footer:
            return tableView.dequeueReusableCell(withIdentifier: HomeFooterCell.identifier, for: indexPath)
        }
    }
}

extension HomeViewController: HomeRankingContainerCellDelegate {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
        print("home Ranking did select at \(index)")
    }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
        print("home recomend cell did select item at \(index)")
    }
}

extension HomeViewController: HomeRecentWatchContainerCellDelegate {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
        print("home recent watch did select at \(index)")
    }
}
