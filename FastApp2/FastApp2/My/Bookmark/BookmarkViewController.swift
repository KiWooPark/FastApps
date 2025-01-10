//
//  BookmarkViewController.swift
//  FastAPP2
//
//  Created by PKW on 1/9/25.
//

import UIKit

class BookmarkViewController: UIViewController {
    @IBOutlet weak var bookmarkTableView: UITableView!
    let viewModel: BookmarkViewModel = .init()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bookmarkTableView.dataSource = self
        self.bookmarkTableView.delegate = self
        
        self.bookmarkTableView.register(
            UINib(nibName: BookmarkCell.identifier, bundle: nil),
            forCellReuseIdentifier: BookmarkCell.identifier
        )
        
        // 데이터 바인딩
        self.viewModel.dataChanged = { [weak self] in
            self?.bookmarkTableView.reloadData()
        }
        // 데이터 로드
        self.viewModel.request()
    }
}

extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.channels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCell.identifier, for: indexPath)
        
        if let cell = cell as? BookmarkCell,
           let data = self.viewModel.channels?[indexPath.row]
        {
            cell.setData(data)
        }
        
        return cell
    }
}

extension BookmarkViewController: UITableViewDelegate {}
