//
//  UIImageView.swift
//  LearnUIKitMiniProject
//
//  Created by Joshua Wenata Sunarto on 08/12/24.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        self.image = UIImage(systemName: "photo")

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
