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
    var menu: Menu = DataController.sharedInstance.menu
    var orders: [Order] = DataController.sharedInstance.orders
    var isOrderConfirmation = false
    var dismissProtocol: DismissProtocol?
    let orderHeaderIdentifier = "OrderTableViewHeaderView"
    let cartCellIdentifier = "CartTableViewCell"
    
    // MARK: IBOutlets
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: IBActions
    
    @IBAction func dismissButtonWasPressed(_ sender: UIButton) {
        if let dismissProtocol = dismissProtocol {
            dismissProtocol.dismiss()
        } else {
            dismiss(animated: true, completion: nil)
        }
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
        if orders.count == 0 {
            displayAlertLabel(withMessage: "Du har inte lagt en beställning än. Gå tillbaka och gör din första beställning.")
        }
    }
}

// MARK: Setup

private extension OrderOverviewViewController {

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
        tableView.estimatedRowHeight = 110
    }
    
    func registerNibs() {
        let orderHeaderNib = UINib(nibName: orderHeaderIdentifier, bundle: nil)
        tableView.register(orderHeaderNib, forHeaderFooterViewReuseIdentifier: orderHeaderIdentifier)
        let cartCellNib = UINib(nibName: cartCellIdentifier, bundle: nil)
        tableView.register(cartCellNib, forCellReuseIdentifier: cartCellIdentifier)
    }
    
    func updateOrder(forHeaderInSection section: Int) {
        DataController.sharedInstance.getOrder(withId: orders[section].orderId) { (order, error) in
            if error != nil {
                self.displayAlertLabel(withMessage: "Misslyckades att uppdatera order")
            }
            
            if !order.isEmpty {
                self.orders = order
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: TableView

extension OrderOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isOrderConfirmation ? 1 : orders.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderHeaderIdentifier) as! OrderTableViewHeaderView
        
        if !isOrderConfirmation, orders.count != 0 {
            updateOrder(forHeaderInSection: section)
        }
        
        let order = orders[section]
        
        let restaurantId = order.restuarantId
        if let restaurant = restaurants.first(where: { $0.id == restaurantId }) {
            view.setRestaurantName(to: restaurant.name)
            view.setAddress(to: restaurant.address1 + ", " + restaurant.address2)
        }
        
        view.setOrderId(to: order.orderId)
        view.setOrderDate(to: format(dateString: order.orderedAt))
        view.setEstimatedDeliveryDate(to: format(dateString: order.esitmatedDelivery))
        view.setDeliveryStatus(to: order.status)
        view.setTotalPrice(to: order.totalPrice)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders[section].cart?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cartCellIdentifier) as! CartTableViewCell
        
        guard let cart = orders[indexPath.section].cart else { return cell }
        let quantity = cart[indexPath.row].quantity
        let menuItemId = cart[indexPath.row].menuItemId
        let menuItem = menu.items.first{ $0.id == menuItemId }!
        
        cell.setQuantity(to: quantity)
        cell.setMenuItem(to: menuItem.name)
        cell.setPricePerUnit(to: menuItem.price)
        cell.setTotalPrice(to: menuItem.price * quantity)
        return cell
    }
}

// MARK: Helpers

private extension OrderOverviewViewController {
    
    func displayAlertLabel(withMessage message: String) {
        let alertLabel = AlertLabel()
        alertLabel.textColor = UIColor.foodlyColor(.white)
        alertLabel.text = message
        alertLabel.frame.size.width = view.frame.width - 30
        alertLabel.sizeToFit()
        alertLabel.center = view.center
        view.addSubview(alertLabel)
    }
    
    func format(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: dateString) else { return dateString}
        dateFormatter.dateFormat = "MMM d yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }
}
