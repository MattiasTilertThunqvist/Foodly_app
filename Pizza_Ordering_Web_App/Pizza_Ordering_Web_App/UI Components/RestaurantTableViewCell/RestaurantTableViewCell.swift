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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: Setup
    
    override func awakeFromNib() {
        logoImageView.layer.cornerRadius = logoImageView.frame.height * 0.5
        logoImageView.layer.setFoodlyCustomShadow()
        
        containerView.layer.setFoodlyCustomShadow()
        containerView.layer.cornerRadius = 10
        
        iconContainerView.layer.cornerRadius = iconContainerView.frame.height * 0.5
        iconContainerView.layer.setFoodlyCustomShadow()
    }
    
    // MARK: Helpers
    
    func setName(to name: String) {
        nameLabel.text = name
    }
    
    func setAdress(adress1: String, address2: String) {
        address1Label.text = adress1
        address2Label.text = address2
    }
    
    class func reuseIdentifier() -> String {
        return "RestaurantTableViewCell"
    }
}
