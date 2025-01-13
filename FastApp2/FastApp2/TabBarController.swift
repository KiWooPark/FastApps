// Created by 박기우
// All rights reserved.

import UIKit

protocol VideoViewControllerContainer {
    var videoViewController: VideoViewController? { get }
    func presentCurrentViewController()
}

class TabBarController: UITabBarController, VideoViewControllerContainer, VideoViewControllerDelegate {
    // 탭바 컨트롤러 세로 방향만 고정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    weak var videoViewController: VideoViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func videoViewController(_ videoViewController: VideoViewController, yPositionForMinizeView height: CGFloat) -> CGFloat {
        return self.tabBar.frame.minY - height
    }
    
    func videoViewControllerDidMinimize(_ videoViewController: VideoViewController) {
        self.videoViewController = videoViewController
        self.addChild(videoViewController)
        self.view.addSubview(videoViewController.view)
        videoViewController.didMove(toParent: self)
    }
    
    func videoViewControllerNeedsMaximize(_ videoViewController: VideoViewController) {
        self.videoViewController = nil
        videoViewController.willMove(toParent: nil)
        videoViewController.view.removeFromSuperview()
        videoViewController.removeFromParent()
        
        
        print("------------------------------")
        print(self.videoViewController)
        
        self.present(videoViewController, animated: true)
    }
    
    func videoViewControllerDidTapClose(_ videoViewController: VideoViewController) {
        videoViewController.willMove(toParent: nil)
        videoViewController.view.removeFromSuperview()
        videoViewController.removeFromParent()
        
        self.videoViewController = nil
    }
    
    func presentCurrentViewController() {
        guard let videoViewController else {
            return
        }

        videoViewController.willMove(toParent: nil)
        videoViewController.view.removeFromSuperview()
        videoViewController.removeFromParent()
        
        self.present(videoViewController, animated: true)
        self.videoViewController = nil
    }
}
