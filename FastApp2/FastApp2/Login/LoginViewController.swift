// Created by 박기우
// All rights reserved.

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!

    // 로그인 뷰 컨트롤러 세로방향 고정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()

        loginBtn.layer.cornerRadius = 19
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor(named: "main-brown")?.cgColor
    }

    @IBAction func loginBtnTapped(_: Any) {
        // 루트 뷰 탭바로 변경하기
        view.window?.rootViewController = storyboard?.instantiateViewController(withIdentifier: "tabbar")
    }
}
