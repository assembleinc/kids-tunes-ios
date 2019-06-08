//
//  ViewExtensions.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/14/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func constrainToBounds(otherView: UIView) {
        self.leadingAnchor.constraint(equalTo: otherView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: otherView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: otherView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor).isActive = true
    }
    
    func addDropshadow() {
        layer.shadowColor = UIColor(named: "AMK-blur-gray")!.cgColor
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
    }
}
