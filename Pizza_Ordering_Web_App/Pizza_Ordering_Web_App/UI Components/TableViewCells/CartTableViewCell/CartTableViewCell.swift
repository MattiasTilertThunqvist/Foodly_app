//
//  CartTableViewCell.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-10-12.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak private var menuItemLabel: UILabel!
    @IBOutlet weak private var pricePerItemLabel: UILabel!
    @IBOutlet weak private var totalPriceLabel: UILabel!
    @IBOutlet weak var quantityContainerView: UIView!
    @IBOutlet weak private var quantityLabel: UILabel!
    
    // MARK: Setup
    
    override func awakeFromNib() {
        containerView.layer.cornerRadius = 10
        containerView.layer.setFoodlyCustomShadow()
        
        quantityContainerView.layer.cornerRadius = quantityContainerView.frame.height * 0.5
        quantityContainerView.layer.setFoodlyCustomShadow()
    }
    
    // MARK: Helpers
    
    func setQuantity(to quantity: Int) {
        quantityLabel.text = "\(quantity)x"
    }
    
    func setMenuItem(to menuItem: String) {
        menuItemLabel.text = menuItem
    }
    
    func setPricePerUnit(to price: Int) {
        pricePerItemLabel.text = "Price per item: \(price) kr"
    }
    
    func setTotalPrice(to price: Int) {
        totalPriceLabel.text = "Total: \(price) kr"
    }
    
    static func reuseIdentifier() -> String {
        return "CartTableViewCell"
    }
}
