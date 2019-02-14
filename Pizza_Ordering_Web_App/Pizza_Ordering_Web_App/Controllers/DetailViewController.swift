//
//  DetailViewController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-01-31.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Properties
    
    let dataController = DataController()
    var restaurant: Restaurant!
    var menu: [MenuItem] = []
    var categories: [String] = []
    var cart: [Cart] = [] {
        didSet {
            handleCartButton()
        }
    }
    let menuCellIdentifier = "MenuItemTableViewCell"
    let animationDuration = 0.3
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartContainerView: UIView!
    @IBOutlet weak var nrOfItemsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cartTapView: UIView!
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMenu()
        setup()
        setupTableView()
        registerNibs()
    }
}

// MARK: Setup

extension DetailViewController {
    
    func setup() {
        title = restaurant.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToCart))
        cartTapView.addGestureRecognizer(tapGesture)
        handleCartButton()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func registerNibs() {
        let cellNib = UINib(nibName: menuCellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: menuCellIdentifier)
    }
    
    func getMenu() {
        let loadingViewController = LoadingViewController()
        add(loadingViewController)
        
        dataController.getMenuForRestaurant(with: restaurant.id) { (menu, error) in
            loadingViewController.remove()
            
            if error != nil {
                let alert = UIAlertController(title: "Kunde inte hämta meny", message: "", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Okej", style: .default, handler: nil)
                alert.addAction(alertAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            } else if let menu = menu {
                for item in menu {
                    if !self.categories.contains(item.category) {
                        self.categories.append(item.category)
                    }
                }
                
                self.menu = menu
                self.sortMenuByRank()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: TableView

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = .pizzaRegularFont(withSize: 20)
            header.textLabel?.textColor = .pizzaColor(.white)
            header.backgroundView?.backgroundColor = .pizzaColor(.green)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let menuItemsInCategory = getMenuItemsIn(category: categories[section])
        return menuItemsInCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItemsInCategory = getMenuItemsIn(category: categories[indexPath.section])
        let menuItem = menuItemsInCategory[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCellIdentifier) as! MenuItemTableViewCell
        cell.setName(to: menuItem.name)
        cell.setPrice(to: menuItem.price)
        cell.setDescription(to: menuItem.topping?.joined(separator: ", ") ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = StoryboardInstance.home
        if let viewController = storyboard.instantiateViewController(withIdentifier: "AddToCartViewController") as? AddToCartViewController {
            
            let menuItemsInCategory = getMenuItemsIn(category: categories[indexPath.section])
            viewController.menuItem = menuItemsInCategory[indexPath.row]
            viewController.restaurant = restaurant
            viewController.addToCartProtocol = self
            viewController.modalPresentationStyle = .overCurrentContext
            present(viewController, animated: false, completion: nil)
        }
    }
}

// MARK: Helpers

extension DetailViewController {
    
    func sortMenuByRank() {
        menu.sort { (item1, item2) -> Bool in
            if let rank1 = item1.rank, let rank2 = item2.rank {
                return item1.category == item2.category && rank1 < rank2
            }
            
            return false
        }
    }
    
    func getMenuItemsIn(category: String) -> [MenuItem] {
        return menu.filter({ $0.category == category })
    }
}

// MARK: SettingsProtocol

extension DetailViewController: UpdateCartProtocol {
    
    func addToCart(_ menuItem: MenuItem, quantity: Int) {
        let newItem = Cart(menuItem: menuItem, quantity: quantity)
        cart.append(newItem)
    }
    
    func removeFromCart(_ menuItem: MenuItem) {
        var index = 0
        
        for item in cart {
            if item.menuItem.id == menuItem.id {
                break
            }
            index += 1
        }
        
        cart.remove(at: index)
    }
}

// MARK: Cart

extension DetailViewController {
    
    func handleCartButton() {
        setCartButtonText()
        cart.isEmpty ? hideCartButton(withAnimation: false) : showCartButton()
    }
    
    func showCartButton() {
        tableView.contentInset.bottom = cartContainerView.frame.height
        
        UIView.animate(withDuration: animationDuration) {
            self.cartContainerView.transform = .identity
            self.cartTapView.transform = .identity
        }
    }
    
    func hideCartButton(withAnimation animation: Bool) {
        let timeInterval = animation ? animationDuration : 0.0
        
        UIView.animate(withDuration: timeInterval, animations: {
            let transformation = CGAffineTransform(translationX: 0,
                                                   y: self.view.bounds.maxY)
            self.cartContainerView.transform = transformation
            self.cartTapView.transform = transformation
        })
    }
    
    func setCartButtonText() {
        let quantity = Cart.quantityOfItems(in: cart)
        let itemString = quantity > 1 ? "varor" : "vara"
        nrOfItemsLabel.text = "\(quantity) \(itemString) i varukorgen"
        
        priceLabel.text = "\(Cart.totalPriceOfItems(in: cart)) kr"
        descriptionLabel.text = "Gå till varukorgen"
    }
    
    @objc func goToCart() {
        let storyboard = StoryboardInstance.home
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            viewController.restaurant = restaurant
            viewController.cart = cart
            viewController.updateCartProtocol = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
