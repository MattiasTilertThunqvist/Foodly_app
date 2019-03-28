//
//  Cart.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-13.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

struct CartItem: Decodable {
    
    // MARK: Properties
    
    let menuItem: MenuItem
    var quantity: Int
    
    // MARK: Helpers
    
    static func totalPriceOfItems(in cart: [CartItem]) -> Int {
        var totalPrice = 0
        
        for item in cart {
            totalPrice += item.menuItem.price * item.quantity
        }
    
        return totalPrice
    }
    
    static func quantityOfItems(in cart: [CartItem]) -> Int {
        var quantity = 0
        
        for item in cart {
            quantity += item.quantity
        }
        
        return quantity
    }
}
