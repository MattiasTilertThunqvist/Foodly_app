//
//  Menu.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-01-31.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

struct MenuItem: Decodable {
    
    // MARK: Properties
    
    let id: Int
    let category: String
    let name: String
    let topping: [String]?
    let price: Int
    let rank: Int?
}
