//
//  Menu.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-10-14.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

struct Menu {
    
    // MARK: Properties
    
    var items: [MenuItem]
    
    // MARK: Helpers
    
    func categories() -> [String] {
        var categories: [String] = []
        
        for item in items {
            if !categories.contains(item.category) {
                categories.append(item.category)
            }
        }
        
        return categories
    }
    
    mutating func sortMenuByRank() {
        items.sort { (item1, item2) -> Bool in
            if let rank1 = item1.rank, let rank2 = item2.rank {
                return item1.category == item2.category && rank1 < rank2
            }
            
            return false
        }
    }
    
    func getItemsIn(category: String) -> [MenuItem] {
        let filteredItems = items.filter({ $0.category == category })
        return filteredItems
    }
}


