//
//  OrderDetails.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-15.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

struct OrderDetails: Codable {
    
    // MARK: Properties
    
    var menuItemId : Int
    var quantity : Int
}
