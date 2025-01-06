//
//  UIImageView+Task.swift
//  FastAPP2
//
//  Created by PKW on 1/6/25.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(url: URL) -> Task<Void, Never> {
        let task = Task {
            do {
                let data = try await NetworkLoader.loadImageData(from: url)
                guard let image = UIImage(data: data), !Task.isCancelled else { return }
                
                self.image = image
            } catch {
                print("loadImage Error")
            }
        }
        
        return task
    }
}
