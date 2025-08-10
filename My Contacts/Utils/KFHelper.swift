//
//  KFHelper.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

import UIKit
import Kingfisher

@objc class KFHelper: NSObject {
    @MainActor @objc static func setImage(_ imageView: UIImageView?, urlString: String?, placeholder: UIImage?) {
        guard let imageView = imageView else { return }
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = placeholder
            return
        }
        imageView.kf.setImage(with: url, placeholder: placeholder)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
    }
}
