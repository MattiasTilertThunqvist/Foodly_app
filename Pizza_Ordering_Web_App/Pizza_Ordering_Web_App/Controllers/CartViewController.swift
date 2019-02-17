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
    var dismissProtocol: DismissProtocol!
    let cellIdentifier = "CartTableViewCell"
    let animationDuration = 0.3
    
    // MARK: UI components
    
    lazy var loadingViewController = LoadingViewController()
    lazy var alertLabel: UILabel = {
        let label = UILabel()
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
        createOrder()
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

private extension CartViewController {
    
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
            if cart.isEmpty {
                displayAlertLabel(withMessage: "Du har inga varor i varukorgen. Gå tillbaka för att lägga till några.")
            }
        }
    }
}

// MARK: Helpers

private extension CartViewController {
    
    func displayAlertLabel(withMessage message: String) {
        alertLabel.text = message
        alertLabel.frame.size = CGSize(width: tableView.frame.width - 30, height: tableView.frame.height)
        alertLabel.center = view.center
        alertLabel.alpha = 0.0
        view.addSubview(alertLabel)
        
        UIView.animate(withDuration: animationDuration) {
            self.tableView.alpha = 0.0
            self.bottomBorderView.alpha = 0.0
            self.totalLabel.alpha = 0.0
            self.priceLabel.alpha = 0.0
            self.orderButton.alpha = 0.0
            self.alertLabel.alpha = 1.0
        }
    }
    
    func createOrder() {
        add(loadingViewController)
        
        let orderDetails = cart.map { OrderDetails.init(menuItemId: $0.menuItem.id, quantity: $0.quantity) }
        let newOrder = NewOrder(orderDetails: orderDetails, restuarantId: restaurant.id)
        
        DataController.sharedInstance.createOrder(newOrder) { (order, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.loadingViewController.remove()
                    self.displayAlertLabel(withMessage: "Beställningen misslyckades. Något gick fel, vi beklagar. Gå tillbaka och gör ett nytt försök.")
                }
            } else {
                self.presentOrderOverview(for: order!)
            }
        }
    }
    
    func presentOrderOverview(for order: Order) {
        if let viewController = StoryboardInstance.home.instantiateViewController(withIdentifier: "OrderOverviewViewController") as? OrderOverviewViewController {
            
            viewController.isOrderConfirmation = true
            viewController.dismissProtocol = dismissProtocol
            
            DispatchQueue.main.async {
                self.loadingViewController.remove()
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
}
