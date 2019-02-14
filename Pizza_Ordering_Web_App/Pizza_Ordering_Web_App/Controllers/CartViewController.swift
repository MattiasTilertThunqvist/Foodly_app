//
//  CartViewController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-13.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    // MARK: Properties
    
    var restaurant: Restaurant!
    var cart: [Cart] = []
    var updateCartProtocol: UpdateCartProtocol!
    let cellIdentifier = "CartTableViewCell"
    let animationDuration = 0.3
    
    // MARK: UI components
    
    lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Du har inga varor i varukorgen. Gå tillbaka för att lägga till några."
        label.font = .pizzaRegularFont(withSize: 25)
        label.textColor = .pizzaColor(.darkGray)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    // Mark: IBAction
    
    @IBAction func orderButtonWasPressed(_ sender: UIButton) {
        
    }
    
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        registerNib()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupContent()
    }
    
    
}

// MARK: Setup

extension CartViewController {
    
    func setup() {
        title = "Varukorg"
        restaurantNameLabel.text = restaurant.name
        orderButton.setTitle("Beställ", for: .normal)
        priceLabel.text = "\(Cart.totalPriceOfItems(in: cart)) kr"
    }
    
    func setupContent() {
        orderButton.layer.cornerRadius = orderButton.frame.height * 0.5
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    func registerNib() {
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
}

// MARK: Functions

extension CartViewController {
    
    func handleEmpyCart() {
        emptyCartLabel.frame.size = CGSize(width: tableView.frame.width * 0.8, height: tableView.frame.height)
        emptyCartLabel.center = view.center
        emptyCartLabel.alpha = 0.0
        view.addSubview(emptyCartLabel)
        
        UIView.animate(withDuration: animationDuration) {
            self.tableView.alpha = 0.0
            self.bottomBorderView.alpha = 0.0
            self.totalLabel.alpha = 0.0
            self.priceLabel.alpha = 0.0
            self.orderButton.alpha = 0.0
            self.emptyCartLabel.alpha = 1.0
        }
    }
}

// MARK: TableView

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CartTableViewCell
        let index = cart[indexPath.row]
        cell.setQuantity(to: index.quantity)
        cell.setMenuItem(to: index.menuItem.name)
        cell.setPricePerUnit(to: index.menuItem.price)
        cell.setTotalPrice(to: index.menuItem.price * index.quantity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.updateCartProtocol.removeFromCart(cart[indexPath.row].menuItem)
            self.cart.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.priceLabel.text = "\(Cart.totalPriceOfItems(in: cart)) kr"
            if cart.isEmpty { handleEmpyCart() }
        }
    }
}
