//
//  Cart.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-13.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

struct Cart {
    let menuItem: MenuItem
    let quantity: Int
    
    static func totalPriceOfItems(in cart: [Cart]) -> Int {
        var totalPrice = 0
        
        for item in cart {
            totalPrice += item.menuItem.price * item.quantity
        }
    
        return totalPrice
    }
    
    static func quantityOfItems(in cart: [Cart]) -> Int {
        var quantity = 0
        
        for item in cart {
            quantity += item.quantity
        }
        
        return quantity
    }
}
