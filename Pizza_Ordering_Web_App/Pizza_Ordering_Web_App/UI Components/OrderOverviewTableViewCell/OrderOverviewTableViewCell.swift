//
//  OrderOverviewTableViewCell.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-15.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class OrderOverviewTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var orderIdInfoLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderDateInfoLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var deliveryDateInfoLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var statusInfoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalPriceInfoLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    // MARK: Helpers
    
    func setRestaurantName(to name: String) {
        restaurantNameLabel.text = name
    }
    
    func setAddress(to address: String) {
        addressLabel.text = address
    }
    
    func setOrderId(to id: Int) {
        orderIdInfoLabel.text = "Order id"
        orderIdLabel.text = "\(id)"
    }
    
    func setOrderDate(to date: String) {
        orderDateInfoLabel.text = "Orderdatum"
        orderDateLabel.text = date
    }
    
    func setEstimatedDeliveryDate(to date: String) {
        deliveryDateInfoLabel.text = "Uppskattad leverans"
        deliveryDateLabel.text = date
    }
    
    func setDeliveryStatus(to status: String) {
        deliveryDateInfoLabel.text = "Leveransstatus"
        deliveryDateLabel.text = status
    }
    
    func setTotalPrice(to price: Int) {
        totalPriceInfoLabel.text = "Total"
        totalPriceLabel.text = "\(price) kr"
    }
}
