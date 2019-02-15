//
//  OrderStatus.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-15.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

struct OrderStatus: Decodable {
    let orderId: Int
    let totalPrice: Int
    let orderedAt: String
    let esitmatedDelivery: String
    let status: String
    let cart: OrderDetails?
    let restuarantId: Int?
}
