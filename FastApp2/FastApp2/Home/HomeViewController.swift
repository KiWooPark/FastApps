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

    private func presentVideoViewController() {
        if let vc = (self.tabBarController as? VideoViewControllerContainer)?.videoViewController {
            (self.tabBarController as? VideoViewControllerContainer)?.presentCurrentViewController()
        } else {
            let vc = VideoViewController()
            vc.delegate = self.tabBarController as? VideoViewControllerDelegate
            self.present(vc, animated: true)
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

        self.videoCollectionView.register(
            UINib(nibName: HomeRankingItemCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRankingItemCell.identifier
        )
        
        self.videoCollectionView.register(
            UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier
        )
        
        // 추천 비디오 아이템
        self.videoCollectionView.register(
            UINib(nibName: HomeRecommendContainerCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecommendContainerCell.identifier
        )

        self.videoCollectionView.dataSource = self
        self.videoCollectionView.delegate = self

        self.videoCollectionView.collectionViewLayout =
            UICollectionViewCompositionalLayout(sectionProvider: { [weak self] section , _ in
                return self?.makeSecton(section)
            })
    }

    fileprivate func makeHeaaderSection() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeHeaderView.height)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [
                .init(
                    layoutSize: .init(
                        widthDimension: .absolute(0.1),
                        heightDimension: .absolute(0.1)
                    )
                )
            ]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: layoutSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]

        return section
    }

    fileprivate func makeVideoSection(_ itemSpace: CGFloat, _ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeVideoCell.height)
        )

        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = itemSpace
        section.contentInsets = inset

        return section
    }

    fileprivate func makeRankingSection(_ itemSpace: CGFloat, _ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection? {
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeRankingHeaderView.height)
        )

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(HomeRankingItemCell.size.width),
            heightDimension: .absolute(HomeRankingItemCell.size.height)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(HomeRankingItemCell.size.width),
                heightDimension: .absolute(265)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpace
        section.contentInsets = inset
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerLayoutSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]

        return section
    }

    fileprivate func makeRecentWatchSection(_ itemSpace: CGFloat, _ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(HomeRecentWatchItemCell.itemSize.width),
            heightDimension: .absolute(HomeRecentWatchItemCell.itemSize.height)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(HomeRecentWatchItemCell.itemSize.width),
                heightDimension: .absolute(189)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpace
        section.contentInsets = inset
        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    fileprivate func makeRecommendSection(_ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeRecommendContainerCell.height(
                viewModel: self.homeViewModel.recommendViewModel))
        )

        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = inset
        return section
    }

    fileprivate func makeFooterSection() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeFooterView.height)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [
                .init(
                    layoutSize: .init(
                        widthDimension: .absolute(0.1),
                        heightDimension: .absolute(0.1)
                    )
                )
            ]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: layoutSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
        ]

        return section
    }

    private func makeSecton(_ section: Int) -> NSCollectionLayoutSection? {
        guard let section = HomeSection(rawValue: section) else { return nil }

        let itemSpace: CGFloat = 21
        let inset: NSDirectionalEdgeInsets = .init(top: 0, leading: 21, bottom: 21, trailing: 21)

        switch section {
        case .header:
            return self.makeHeaaderSection()
        case .video:
            return self.makeVideoSection(itemSpace, inset)
        case .ranking:
            return self.makeRankingSection(itemSpace, inset)
        case .recentWatch:
            return self.makeRecentWatchSection(itemSpace, inset)
        case .recommend:
            return self.makeRecommendSection(inset)
        case .footer:
            return self.makeFooterSection()
        }
    }

    private func makeHeaderSection() {}
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
            return self.homeViewModel.homeModel?.videos.count ?? 0
        case .ranking:
            return self.homeViewModel.homeModel?.rankings.count ?? 0
        case .recentWatch:
            return self.homeViewModel.homeModel?.recents.count ?? 0
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
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeVideoCell.identifire,
                for: indexPath
            )

            if let cell = cell as? HomeVideoCell,
               let data = self.homeViewModel.homeModel?.videos[indexPath.item]
            {
                cell.setData(data)
            }

            return cell
        case .ranking:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeRankingItemCell.identifier,
                for: indexPath
            )

            if let cell = cell as? HomeRankingItemCell,
               let data = self.homeViewModel.homeModel?.rankings[indexPath.item]
            {
                cell.setData(data, indexPath.item + 1)
            }
            
            return cell
        case .recentWatch:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeRecentWatchItemCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? HomeRecentWatchItemCell,
               let data = self.homeViewModel.homeModel?.recents[indexPath.item] {
                cell.setData(data)
            }
            
            return cell
        case .recommend:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeRecommendContainerCell.identifier,
                for: indexPath
            )

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

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .header, .footer, .ranking, .recentWatch, .recommend:
            return
        case .video:
            self.presentVideoViewController()
        }
    }
}

extension HomeViewController: HomeRankingContainerCellDelegate {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
        self.presentVideoViewController()
    }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
        self.videoCollectionView.collectionViewLayout.invalidateLayout()
    }

    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
        self.presentVideoViewController()
    }
}

extension HomeViewController: HomeRecentWatchContainerCellDelegate {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
        self.presentVideoViewController()
    }
}
