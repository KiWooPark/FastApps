//
//  MoreViewController.swift
//  FastAPP2
//
//  Created by PKW on 1/7/25.
//

import UIKit

class MoreViewController: UIViewController {
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSettingTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.setupConerRadius()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate { _ in
            self.setupConerRadius()
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setupSettingTableView() {
        self.settingTableView.dataSource = self
        self.settingTableView.delegate = self
        self.settingTableView.rowHeight = 48
        self.settingTableView.register(
            UINib(nibName: MoreTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: MoreTableViewCell.identifier
        )
    }
    
    private func setupConerRadius() {
        let path = UIBezierPath(
            roundedRect: self.headerView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 13, height: 13)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.headerView.layer.mask = maskLayer
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: false)
    }
}

extension MoreViewController: UITableViewDelegate {}

extension MoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.identifier, for: indexPath)
        return cell
    }
}
