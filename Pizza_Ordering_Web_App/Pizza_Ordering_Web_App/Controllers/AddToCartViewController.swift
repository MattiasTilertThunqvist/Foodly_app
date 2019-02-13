//
//  AddToCartViewController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-02-12.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class AddToCartViewController: UIViewController {
    
    // MARK: Properties
    var restaurant: Restaurant!
    var menuItem: MenuItem!
    let animationDuration = 0.3
    var numberOfItems = 1
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    // MARK: IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var menuItemLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pricePerUnitLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    // MARK: IBActions
    
    @IBAction func dismissButtonWasPressed(_ sender: UIButton) {
        dismissView()
    }
    
    @IBAction func removeItemButtonWasPressed(_ sender: UIButton) {
        numberOfItems -= 1
        nrOfItemsDidChange()
    }
    
    @IBAction func addItemButtonWasPressed(_ sender: UIButton) {
        numberOfItems += 1
        nrOfItemsDidChange()
    }
    
    @IBAction func addToCartButtonWasPressed(_ sender: UIButton) {
        addToCart()
    }
    
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupContent()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentWillShow()
    }
}

// MARK: Setup

extension AddToCartViewController {
    
    func setup() {
        restaurantNameLabel.text = restaurant.name
        menuItemLabel.text = menuItem.name
        descriptionLabel.text = menuItem.topping?.joined(separator: ", ") ?? ""
        pricePerUnitLabel.text = menuItem.price > 0 ? "\(menuItem.price) kr" : "Gratis"
        addToCartButton.setTitle("Lägg i varukorgen", for: .normal)
        setTotalPrice()
    }
    
    func setupContent() {
        view.backgroundColor = UIColor.clear
        
        blurEffectView.frame = view.bounds
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        blurEffectView.addGestureRecognizer(tapGesture)
        view.insertSubview(blurEffectView, at: 0)
        
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        dismissButton.layer.cornerRadius = dismissButton.frame.height * 0.5
        removeItemButton.layer.cornerRadius = removeItemButton.frame.height * 0.5
        addItemButton.layer.cornerRadius = addItemButton.frame.height * 0.5
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height * 0.5
        
        removeItemButton.isUserInteractionEnabled = false
        
        contentWillHide(withAnimation: false)
    }
}


// MARK: Functions

extension AddToCartViewController {
    
    func contentWillShow() {
        UIView.animate(withDuration: 0.3) {
            self.blurEffectView.alpha = 1.0
            self.containerView.transform = .identity
        }
    }
    
    func contentWillHide(withAnimation animation: Bool) {
        let timeInterval = animation ? 0.3 : 0.0
        
        UIView.animate(withDuration: timeInterval) {
            self.blurEffectView.alpha = 0.0
            self.containerView.transform = CGAffineTransform(translationX: 0,
                                                             y: self.containerView.frame.height)
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    func setTotalPrice() {
        let totalPrice = numberOfItems * menuItem.price
        self.totalPriceLabel.text = "\(numberOfItems) för \(totalPrice) kr"
    }
    
    func nrOfItemsDidChange() {
        removeItemButton.isUserInteractionEnabled = numberOfItems > 1
        setTotalPrice()
    }
    
    func addToCart() {
        
        print("Add to cart")
    }
}
