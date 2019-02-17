//
//  MenuItemTableViewCell.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-01-31.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    // MARK: IBOutlet
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    
    // MARK: Helpers
    
    func setName(to name: String) {
        nameLabel.text = name
    }
    
    func setDescription(to description: String) {
        descriptionLabel.text = description
    }
    
    func setPrice(to price: Int) {
        priceLabel.text = price > 0 ? "\(price) kr" : "Gratis"
    }
}
