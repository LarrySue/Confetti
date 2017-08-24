//
//  Tools.swift
//  ConfettiSwift
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

import Foundation
import UIKit

// MARK: -

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

// MARK: - 

extension UIColor {
    convenience init(red: Double, green: Double, blue: Double) {
        self.init(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: 1.0)
    }
}
