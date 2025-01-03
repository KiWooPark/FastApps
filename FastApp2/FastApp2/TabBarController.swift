// Created by 박기우
// All rights reserved.

import UIKit

class TabBarController: UITabBarController {
    // 탭바 컨트롤러 세로 방향만 고정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
