//
//  Order.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-10-12.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

struct NewOrder: Encodable {
    
    // MARK: Properties
    
    var orderDetails: [OrderDetails]
    var restuarantId: Int
}

struct OrderDetails: Codable {
    
    // MARK: Properties
    
    var menuItemId : Int
    var quantity : Int
}
