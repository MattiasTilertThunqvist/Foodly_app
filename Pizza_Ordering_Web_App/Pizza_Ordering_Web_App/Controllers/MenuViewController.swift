//
//  MenuViewController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-11-10.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: Properties
    
    var restaurant: Restaurant!
    var menu = Menu(items: [])
    var cart: [CartItem] = [] {
        didSet {
            handleCartButton()
        }
    }
    var dismissProtocol: DismissProtocol!
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
        setup()
        setupTableView()
        registerNibs()
        getMenu()
    }
}

// MARK: Setup

private extension MenuViewController {
    
    func setup() {
        title = restaurant.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToCart))
        cartTapView.addGestureRecognizer(tapGesture)
        cartContainerView.layer.setFoodlyCustomShadow()
        handleCartButton()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
    }
    
    func registerNibs() {
        let identifier = MenuItemTableViewCell.reuseIdentifier()
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
    }
    
    func getMenu() {
        let loadingViewController = LoadingViewController()
        add(loadingViewController)
        
        DataController.getMenuForRestaurant(withId: restaurant.id) { (menu, error) in
            loadingViewController.remove()
            
            guard let menu = menu, error == nil else {
                let alert = UIAlertController(title: "Kunde inte hämta meny", message: "", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Okej", style: .default, handler: nil)
                alert.addAction(alertAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.menu = menu
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: TableView

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.categories().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menu.categories()[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = .foodlyRegularFont(withSize: 20)
            header.textLabel?.textColor = .foodlyColor(.white)
            header.backgroundView?.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: Row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = menu.categories()[section]
        let menuItemsInCategory = menu.getItemsIn(category: category)
        return menuItemsInCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = menu.categories()[indexPath.section]
        let menuItemsInCategory = menu.getItemsIn(category: category)
        let menuItem = menuItemsInCategory[indexPath.row]
        
        let identifier = MenuItemTableViewCell.reuseIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! MenuItemTableViewCell
        cell.selectionStyle = .none
        cell.setName(to: menuItem.name)
        cell.setPrice(to: menuItem.price)
        cell.setDescription(to: menuItem.topping?.joined(separator: ", ") ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = StoryboardInstance.home
        if let viewController = storyboard.instantiateViewController(withIdentifier: "AddToCartViewController") as? AddToCartViewController {
            let category = menu.categories()[indexPath.section]
            let menuItemsInCategory = menu.getItemsIn(category: category)
            let selectedMenuItem = menuItemsInCategory[indexPath.row]
            
            viewController.menuItem = selectedMenuItem
            viewController.restaurant = restaurant
            viewController.addToCartProtocol = self
            viewController.modalPresentationStyle = .overCurrentContext
            
            present(viewController, animated: false, completion: nil)
        }
    }
}

// MARK: Cart

private extension MenuViewController {
    
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
        tableView.contentInset.bottom = 0.0
        let timeInterval = animation ? animationDuration : 0.0
        
        UIView.animate(withDuration: timeInterval, animations: {
            let transformation = CGAffineTransform(translationX: 0,
                                                   y: self.view.bounds.maxY)
            self.cartContainerView.transform = transformation
            self.cartTapView.transform = transformation
        })
    }
    
    func setCartButtonText() {
        let quantity = CartItem.quantityOfItems(in: cart)
        let itemString = quantity > 1 ? "varor" : "vara"
        nrOfItemsLabel.text = "\(quantity) \(itemString) i varukorgen"
        
        priceLabel.text = "\(CartItem.totalPriceOfItems(in: cart)) kr"
        descriptionLabel.text = "Gå till varukorgen"
    }
    
    @objc func goToCart() {
        let storyboard = StoryboardInstance.home
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            viewController.restaurant = restaurant
            viewController.cart = cart
            viewController.updateCartProtocol = self
            viewController.dismissProtocol = dismissProtocol
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: UpdateCartProtocol

extension MenuViewController: UpdateCartProtocol {
    
    func addToCart(_ menuItem: MenuItem, quantity: Int) {
        if let index = cart.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
            cart[index].quantity += quantity
        } else {
            let newItem = CartItem(menuItem: menuItem, quantity: quantity)
            cart.append(newItem)
        }
    }
    
    func removeFromCart(_ menuItem: MenuItem) {
        cart.removeAll(where: { $0.menuItem.id == menuItem.id })
    }
}
