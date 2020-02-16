//
//  AddToCartProtocol.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-10-12.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

protocol UpdateCartProtocol {
    func addToCart(_ menuItem: MenuItem, quantity: Int)
    func removeFromCart(_ menuItem: MenuItem)
}
