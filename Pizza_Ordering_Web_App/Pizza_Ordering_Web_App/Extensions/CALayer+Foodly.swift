//
//  CALayer+Foodly.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-03-25.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

extension CALayer {
    
    func setFoodlyCustomShadow() {
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 0.2
        self.shadowOffset = CGSize.zero
    }
}
