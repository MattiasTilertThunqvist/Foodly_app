//
//  RestaurantTableViewCell.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-01-31.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    
    // MARK: Helpers
    
    func setName(to name: String) {
        nameLabel.text = name
    }
    
    func setAdress(to adress: String) {
        addressLabel.text = adress
    }
}
