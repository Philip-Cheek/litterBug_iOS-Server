//
//  File.swift
//  litteriOS
//
//  Created by Philip Cheek on 6/2/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import UIKit

extension UIColor {
    static func createColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor{
        return UIColor(
            red: r/255.0,
            green: g/255.0,
            blue: b/255.0,
            alpha: a
        )
    }
    
    static func brandGreen() -> UIColor{
        return UIColor.createColor(76.0, g: 212.0, b: 176.0, a: 1.0)
    }
    
    static func brandBlue() -> UIColor{
        return UIColor.createColor(0.0, g: 64.0, b: 116.0, a: 1.0)
    }
}
