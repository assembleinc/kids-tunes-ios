//
//  UIColorExtensions.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/17/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let characterSet = NSCharacterSet.whitespacesAndNewlines as! NSMutableCharacterSet
        characterSet.formUnion(with: NSCharacterSet.init(charactersIn: "#") as CharacterSet)
        let cString = hex.trimmingCharacters(in: characterSet as CharacterSet).uppercased()
        if (cString.count != 6) {
            self.init(white: 1.0, alpha: 1.0)
        } else {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: CGFloat(1.0))
        }
    }
}
