//
//  CartTableViewCell.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-14.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak private var quantityContainerView: UIView!
    @IBOutlet weak private var quantityLabel: UILabel!
    @IBOutlet weak private var menuItemLabel: UILabel!
    @IBOutlet weak private var pricePerItemLabel: UILabel!
    @IBOutlet weak private var totalPriceLabel: UILabel!
    
    // MARK: Helpers
    
    func setQuantity(to quantity: Int) {
        quantityLabel.text = "\(quantity)x"
    }
    
    func setMenuItem(to menuItem: String) {
        menuItemLabel.text = menuItem
    }
    
    func setPricePerUnit(to price: Int) {
        pricePerItemLabel.text = "\(price) kr per vara"
    }
    
    func setTotalPrice(to price: Int) {
        totalPriceLabel.text = "\(price) kr"
    }
}
