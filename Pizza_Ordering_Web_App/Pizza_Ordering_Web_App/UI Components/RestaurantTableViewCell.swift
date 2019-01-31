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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func setName(name: String) {
        nameLabel.text = name
    }
    
    func setAdress(adress1: String, adress2: String) {
        addressLabel.text = adress1 + ", " + adress2
    }
}
