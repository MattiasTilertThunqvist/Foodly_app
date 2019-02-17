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
    var orderStatus: [OrderStatus] = DataController.sharedInstance.orderStatus
    var isOrderConfirmation = false
    var dismissProtocol: DismissProtocol?
    let orderHeaderIdentifier = "OrderTableViewHeaderView"
    let cartCellIdentifier = "CartTableViewCell"
    
    // MARK: UI components
    
    lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.font = .pizzaRegularFont(withSize: 25)
        label.textColor = .pizzaColor(.darkGray)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
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
        if orderStatus.count == 0 {
            displayAlertLabel(withMessage: "Du har inte lagt en beställning än. Gå tillbaka och gör din första beställning.")
        }
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
    
    func updateOrderStatus(forHeaderInSection section: Int) {
        DataController.sharedInstance.getOrder(withId: orderStatus[section].orderId) { (orderStatus, error) in
            if error != nil {
                self.displayAlertLabel(withMessage: "Misslyckades att uppdatera order")
            }
            
            if !orderStatus.isEmpty {
                self.orderStatus = orderStatus
                
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
        return isOrderConfirmation ? 1 : orderStatus.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderHeaderIdentifier) as! OrderTableViewHeaderView
        
        if !isOrderConfirmation, orderStatus.count != 0 {
            updateOrderStatus(forHeaderInSection: section)
        }
        
        let order = orderStatus[section]
        
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
        return orderStatus[section].cart?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cartCellIdentifier) as! CartTableViewCell
        
        guard let cart = orderStatus[indexPath.section].cart else { return cell }
        let quantity = cart[indexPath.row].quantity
        let menuItemId = cart[indexPath.row].menuItemId
        let menuItem = menu.first{ $0.id == menuItemId }!
        
        cell.setQuantity(to: quantity)
        cell.setMenuItem(to: menuItem.name)
        cell.setPricePerUnit(to: menuItem.price)
        cell.setTotalPrice(to: menuItem.price * quantity)
        return cell
    }
}

// MARK: Functions

extension OrderOverviewViewController {
    
    func displayAlertLabel(withMessage message: String) {
        alertLabel.text = message
        alertLabel.frame.size = CGSize(width: view.frame.width - 30, height: view.frame.height * 0.5)
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
