//
//  FavoriteViewController.swift
//  FastAPP2
//
//  Created by PKW on 1/9/25.
//

import UIKit

class FavoriteViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    let viewModel: FavoriteViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.favoriteTableView.dataSource = self
        self.favoriteTableView.delegate = self
        self.favoriteTableView.separatorInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
        
        self.favoriteTableView.register(
            UINib(nibName: VideoListItemCell.identifier, bundle: nil),
            forCellReuseIdentifier: VideoListItemCell.identifier
        )
        
        self.viewModel.dataChanged = { [weak self] in
            self?.favoriteTableView.reloadData()
        }
        
        self.viewModel.request()
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VideoListItemCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favorite?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoListItemCell.identifier, for: indexPath)
        
        if let cell = cell as? VideoListItemCell,
           let data = self.viewModel.favorite?.list[indexPath.row]
        {
            cell.setData(data, rank: nil)
            cell.setLeadingConstraint(21)
        }
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {}
