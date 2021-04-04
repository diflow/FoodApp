//
//  UIColor+Ext.swift
//  FoodApp
//Calico
//  Created by ivan on 27.03.2021.
//

import UIKit

extension UIColor {
    struct App {
        static let blackSqueeze = UIColor(red: 250, green: 250, blue: 248)
        static let bilbao = UIColor(red: 74, green: 126, blue: 44)
        static let calico = UIColor(red: 211, green: 177, blue: 129)
        static let bostonBlue = UIColor(red: 74, green: 166, blue: 174)
    }
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat? = nil) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha ?? 1)
    }
}
