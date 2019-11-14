//
//  UIColor+Pizza.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-13.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

enum AssetsColor {
    case red
    case white
    case lightGray
    case darkGray
}

extension UIColor {
    static func foodlyColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .red:
            return UIColor(named: "foodlyRed")!
        case .white:
            return UIColor(named: "foodlyWhite")!
        case .lightGray:
            return UIColor(named: "foodlyLightGray")!
        case .darkGray:
            return UIColor(named: "foodlyDarkGray")!
        }
    }
}
