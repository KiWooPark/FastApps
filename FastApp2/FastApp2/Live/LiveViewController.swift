//
//  LiveViewController.swift
//  FastAPP2
//
//  Created by PKW on 1/10/25.
//

import UIKit

class LiveViewController: UIViewController {
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private let viewModel: LiveViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(
            UINib(nibName: LiveCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveCell.identifier
        )
        
        self.bindViewModel()
        self.viewModel.request(sort: .favorite)
    }
    
    private func bindViewModel() {
        self.viewModel.dataChanged = { [weak self] _ in
            self?.collectionView.reloadData()
            self?.collectionView.setContentOffset(.zero, animated: true)
        }
    }
    
    @IBAction func sortBtnTapped(_ sender: UIButton) {
        guard sender.isSelected == false else { return }
        
        self.favoriteButton.isSelected = sender == self.favoriteButton
        self.startTimeButton.isSelected = sender == self.startTimeButton
        
        if self.favoriteButton.isSelected {
            self.viewModel.request(sort: .favorite)
        } else {
            self.viewModel.request(sort: .start)
        }
    }
}

extension LiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: LiveCell.height)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension LiveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = VideoViewController()
        vc.isLiveMode = true
        self.present(vc, animated: true)
    }
}

extension LiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveCell.identifier, for: indexPath)
        
        if let cell = cell as? LiveCell,
           let data = self.viewModel.items?[indexPath.item]
        {
            cell.setData(data)
        }
        
        return cell
    }
}
