//
//  LoginViewController.swift
//  FastAPP2
//
//  Created by PKW on 12/9/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        loginBtn.layer.cornerRadius = 19
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor(named: "main-brown")?.cgColor
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        // 루트 뷰 탭바로 변경하기
        self.view.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
        
    }
}

