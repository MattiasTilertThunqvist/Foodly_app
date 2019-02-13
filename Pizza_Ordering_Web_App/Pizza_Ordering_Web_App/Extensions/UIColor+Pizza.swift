//
//  UIColor+Pizza.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-13.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

enum AssetsColor {
    case green
    case white
    case lightGray
    case darkGray
}

extension UIColor {
    static func pizzaColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .green:
            return UIColor(named: "pizzaGreen")!
        case .white:
            return UIColor(named: "pizzaWhite")!
        case .lightGray:
            return UIColor(named: "pizzaLightGray")!
        case .darkGray:
            return UIColor(named: "pizzaDarkGray")!
        }
    }
}
