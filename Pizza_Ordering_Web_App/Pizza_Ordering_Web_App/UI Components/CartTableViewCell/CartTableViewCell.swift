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
    
    @IBOutlet weak var quantityContainerView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var menuItemLabel: UILabel!
    @IBOutlet weak var pricePerItemLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
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
