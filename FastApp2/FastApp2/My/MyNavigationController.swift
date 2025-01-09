//
//  MyNavigationController.swift
//  FastAPP2
//
//  Created by PKW on 1/9/25.
//

import UIKit

class MyNavigationController: UINavigationController {
    
    // 여기서 상태바 옵션 설정 해줘야함
    override var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
