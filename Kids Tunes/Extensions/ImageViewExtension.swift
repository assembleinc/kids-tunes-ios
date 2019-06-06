//
//  ImageViewExtension.swift
//  reDiscover
//
//  Created by Gabriel Sosa on 6/15/18.
//  Copyright © 2018 Assemble. All rights reserved.
//

import UIKit
import Kingfisher

class PlaceholderImage : UIView, Placeholder {
    init() {
        super.init(frame: CGRect.zero)
        self.sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }

    func sharedInit() {
        self.backgroundColor = UIColor.lightGray
    }
}

extension UIImageView {
    public func setImage(urlString: String) {
        let url = URL(string: urlString)!
        self.setImage(url: url)
    }
 
    public func setImage(url: URL, placeholder: Image? = nil) {
        let placeHolderImage = PlaceholderImage()
        if let placeHolder = placeholder {
            placeHolderImage.add(to: UIImageView(image: placeHolder))
        }
        self.kf.setImage(with: url, placeholder: placeHolderImage)
    }
}

extension UIButton {
    public func setBackgroundImage(urlString: String, for controlState: UIControl.State) {
        let url = URL(string: urlString)!
        self.setBackgroundImage(url: url,  for: controlState)
    }

    public func setBackgroundImage(url: URL, for controlState: UIControl.State) {
        self.kf.setBackgroundImage(with: url, for: controlState)
    }
}
