//
//  OrderOverviewViewController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-15.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class OrderOverviewViewController: UIViewController {
    
    // MARK: Properties
    
    var restaurants: [Restaurant] = DataController.sharedInstance.restaurants
    var menu: [MenuItem] = DataController.sharedInstance.menu
//    var orderStatus: [OrderStatus] = DataController.sharedInstance.orderStatus
    //Mocked data
    var orderStatus: [OrderStatus] = {
        let orderDetails = [OrderDetails(menuItemId: 2, quantity: 1),
                            OrderDetails(menuItemId: 3, quantity: 1),
                            OrderDetails(menuItemId: 6, quantity: 2)]
        
       let order = OrderStatus(orderId: 1234412, totalPrice: 168, orderedAt: "2015-04-09T17:30:47.556Z", esitmatedDelivery: "2015-04-09T17:45:47.556Z", status: "ordered", cart: orderDetails, restuarantId: 1)
        
        
        return [order, order]
    }()

    var isOrderConfirmation = false
    let orderHeaderIdentifier = "OrderTableViewHeaderView"
    let cartCellIdentifier = "CartTableViewCell"
    
    // MARK: IBOutlets
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: IBActions
    
    @IBAction func dismissButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        registerNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupContent()
    }
}

// MARK: Setup

extension OrderOverviewViewController {

    func setup() {
        headerLabel.text = isOrderConfirmation ? "Orderbekräftelse" : "Mina ordrar"
    }
    
    func setupContent() {
        dismissButton.layer.cornerRadius = dismissButton.frame.height * 0.5
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 230
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    func registerNibs() {
        let orderHeaderNib = UINib(nibName: orderHeaderIdentifier, bundle: nil)
        tableView.register(orderHeaderNib, forHeaderFooterViewReuseIdentifier: orderHeaderIdentifier)
        let cartCellNib = UINib(nibName: cartCellIdentifier, bundle: nil)
        tableView.register(cartCellNib, forCellReuseIdentifier: cartCellIdentifier)
    }
}

// MARK: TableView

extension OrderOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isOrderConfirmation ? 1 : orderStatus.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderHeaderIdentifier) as! OrderTableViewHeaderView
        
        let order = orderStatus[section]
        
        let restaurantId = order.restuarantId
        if let restaurant = restaurants.first(where: { $0.id == restaurantId }) {
            view.setRestaurantName(to: restaurant.name)
            view.setAddress(to: restaurant.address1 + ", " + restaurant.address2)
        }
        
        view.setOrderId(to: order.orderId)
        
        let deliveryDate = format(dateString: order.orderedAt)
        view.setOrderDate(to: deliveryDate)
        
        let estimatedDeliveryDate = format(dateString: order.esitmatedDelivery)
        view.setEstimatedDeliveryDate(to: estimatedDeliveryDate)
        
        view.setDeliveryStatus(to: order.status)
        view.setTotalPrice(to: order.totalPrice)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderStatus[section].cart?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartCell = tableView.dequeueReusableCell(withIdentifier: cartCellIdentifier) as! CartTableViewCell
        return cartCell
    }
}

extension OrderOverviewViewController {
    
    func format(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: dateString) else { return dateString}
        dateFormatter.dateFormat = "MMM d yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }
}
