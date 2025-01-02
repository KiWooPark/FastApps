//
//  HomeViewController.swift
//  FastAPP2
//
//  Created by PKW on 12/9/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var videoTableView: UITableView!
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
        case .recommend:
            return tableView.dequeueReusableCell(withIdentifier: HomeRecommendContainerCell.identifier, for: indexPath)
        case .footer:
            return tableView.dequeueReusableCell(withIdentifier: HomeFooterCell.identifier, for: indexPath)
        }
    }
}
