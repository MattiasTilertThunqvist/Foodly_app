//
//  Order.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-15.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

struct Order: Encodable {
    var cart: [OrderDetails]
    var restuarantId: Int
}
