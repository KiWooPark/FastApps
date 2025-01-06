// Created by 박기우
// All rights reserved.

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var videoCollectionView: UICollectionView!
    private let homeViewModel: HomeViewModel = .init()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupVideoCollectionView()
        
        self.bindViewModel()
        
        self.homeViewModel.requestData()
    }
    
    private func bindViewModel() {
        self.homeViewModel.dataChanged = { [weak self] in
            self?.videoCollectionView.isHidden = false
            self?.videoCollectionView.reloadData()
        }
    }

    func setupVideoCollectionView() {
        // 헤더 뷰
        self.videoCollectionView.register(
            UINib(nibName: HomeHeaderView.identifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderView.identifier
        )

        // 랭킹 헤더 뷰
        self.videoCollectionView.register(
            UINib(nibName: HomeRankingHeaderView.identifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeRankingHeaderView.identifier
        )

        // 푸터 뷰
        self.videoCollectionView.register(
            UINib(nibName: HomeFooterView.identifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: HomeFooterView.identifier
        )

        // 비디오 아이템
        self.videoCollectionView.register(
            UINib(nibName: HomeVideoCell.identifire, bundle: nil),
            forCellWithReuseIdentifier: HomeVideoCell.identifire
        )

        // 랭킹 아이템
        self.videoCollectionView.register(
            UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRankingContainerCell.identifier
        )

        // 최근 시청 비디오 아이템
        self.videoCollectionView.register(
            UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecentWatchContainerCell.identifier
        )

        // 추천 비디오 아이템
        self.videoCollectionView.register(
            UINib(nibName: HomeRecommendContainerCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecommendContainerCell.identifier
        )

        self.videoCollectionView.dataSource = self
        self.videoCollectionView.delegate = self
    }
}

// 헤더 푸터 뷰 높이
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 헤더 뷰 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let section = HomeSection(rawValue: section) else { return .zero }

        switch section {
        case .header:
            return CGSize(width: collectionView.frame.width, height: HomeHeaderView.height)
        case .ranking:
            return CGSize(width: collectionView.frame.width, height: HomeRankingHeaderView.height)
        case .video, .recentWatch, .recommend, .footer:
            return .zero
        }
    }

    // 푸터 뷰 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let section = HomeSection(rawValue: section) else { return .zero }

        switch section {
        case .footer:
            return CGSize(width: collectionView.frame.width, height: HomeFooterView.height)
        case .header, .ranking, .video, .recentWatch, .recommend:
            return .zero
        }
    }

    // 아이템 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = HomeSection(rawValue: indexPath.section) else { return .zero }

        let inset = self.insetForSection(section)
        let width = collectionView.frame.width - inset.left - inset.right

        switch section {
        case .header, .footer:
            return .zero
        case .video:
            return .init(width: width, height: HomeVideoCell.height)
        case .ranking:
            return .init(width: width, height: HomeRankingContainerCell.height)
        case .recentWatch:
            return .init(width: width, height: HomeRecentWatchContainerCell.height)
        case .recommend:
            return .init(
                width: width,
                height: HomeRecommendContainerCell.height(viewModel: self.homeViewModel.recommendViewModel)
            )
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = HomeSection(rawValue: section) else {
            return .zero
        }

        return self.insetForSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = HomeSection(rawValue: section) else { return 0 }

        switch section {
        case .header, .footer:
            return 0
        case .video, .ranking, .recentWatch, .recommend:
            return 21
        }
    }

    private func insetForSection(_ section: HomeSection) -> UIEdgeInsets {
        switch section {
        case .header, .footer:
            return .zero
        case .video, .ranking, .recentWatch, .recommend:
            return .init(top: 0, left: 21, bottom: 21, right: 21)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else { return 0 }

        switch section {
        case .header:
            return 0
        case .video:
            return 2
        case .ranking:
            return 1
        case .recentWatch:
            return 1
        case .recommend:
            return 1
        case .footer:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch section {
        case .header, .footer:
            return UICollectionViewCell()
        case .video:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeVideoCell.identifire, for: indexPath)
            
            if let cell = cell as? HomeVideoCell, let data = self.homeViewModel.homeModel?.videos[indexPath.item] {
                cell.setData(data)
            }
            
            return cell
        case .ranking:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRankingContainerCell.identifier, for: indexPath)
            return cell
        case .recentWatch:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecentWatchContainerCell.identifier, for: indexPath)
            return cell
        case .recommend:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecommendContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecommendContainerCell {
                cell.delegate = self
                cell.setViewModel(self.homeViewModel.recommendViewModel)
            }
            return cell
        }
    }

    // 헤더 푸터 등록
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = HomeSection(rawValue: indexPath.section) else { return .init() }

        switch section {
        case .header:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeHeaderView.identifier,
                for: indexPath
            )
        case .ranking:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeRankingHeaderView.identifier,
                for: indexPath
            )
        case .footer:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeFooterView.identifier,
                for: indexPath
            )
        case .video, .recentWatch, .recommend:
            return .init()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {}

extension HomeViewController: HomeRankingContainerCellDelegate {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
        print("home Ranking did select at \(index)")
    }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
        self.videoCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
        print("home recomend cell did select item at \(index)")
    }
}

extension HomeViewController: HomeRecentWatchContainerCellDelegate {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
        print("home recent watch did select at \(index)")
    }
}
