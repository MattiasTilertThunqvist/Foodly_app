//
//  OrderTableViewHeaderView.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-10-13.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class OrderTableViewHeaderView: UITableViewHeaderFooterView {
    
    // MARK: IBOutlets
    
    @IBOutlet weak private var restaurantNameLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var orderIdInfoLabel: UILabel!
    @IBOutlet weak private var orderIdLabel: UILabel!
    @IBOutlet weak private var orderDateInfoLabel: UILabel!
    @IBOutlet weak private var orderDateLabel: UILabel!
    @IBOutlet weak private var deliveryDateInfoLabel: UILabel!
    @IBOutlet weak private var deliveryDateLabel: UILabel!
    @IBOutlet weak private var statusInfoLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var totalPriceInfoLabel: UILabel!
    @IBOutlet weak private var totalPriceLabel: UILabel!
    
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
        statusInfoLabel.text = "Leveransstatus"
        statusLabel.text = status
    }
    
    func setTotalPrice(to price: Int) {
        totalPriceInfoLabel.text = "Total"
        totalPriceLabel.text = "\(price) kr"
    }
    
    static func reuseIdentifier() -> String {
        return "OrderTableViewHeaderView"
    }
}
