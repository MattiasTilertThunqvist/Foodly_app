//
//  AddToCartViewController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-10-12.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit

class AddToCartViewController: UIViewController {
    
    // MARK: Properties
    
    var restaurant: Restaurant!
    var menuItem: MenuItem!
    var addToCartProtocol: UpdateCartProtocol!
    let animationDuration = 0.3
    var quantityOfItem = 1
    
    // MARK: UI components
    
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
    @IBOutlet weak var decreaseQuantityButton: UIButton!
    @IBOutlet weak var increaseQuantityButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    // MARK: IBActions
    
    @IBAction func dismissButtonWasPressed(_ sender: UIButton) {
        dismissView()
    }
    
    @IBAction func removeItemButtonWasPressed(_ sender: UIButton) {
        quantityOfItem -= 1
        quantityDidChange()
    }
    
    @IBAction func addItemButtonWasPressed(_ sender: UIButton) {
        quantityOfItem += 1
        quantityDidChange()
    }
    
    @IBAction func addToCartButtonWasPressed(_ sender: UIButton) {
        addToCartProtocol.addToCart(menuItem, quantity: quantityOfItem)
        dismissView()
    }
    
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showContent()
    }
}

// MARK: Setup

private extension AddToCartViewController {
    
    func setup() {
        restaurantNameLabel.text = restaurant.name
        menuItemLabel.text = menuItem.name
        descriptionLabel.text = menuItem.topping?.joined(separator: ", ") ?? ""
        pricePerUnitLabel.text = menuItem.price > 0 ? "\(menuItem.price) kr" : "Gratis"
        addToCartButton.setTitle("Lägg i varukorgen", for: .normal)
        setTotalPrice()
        quantityDidChange()
        hideContent(withAnimation: false, completion: nil)
    }
    
    func setupContent() {        
        blurEffectView.frame = view.bounds
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        blurEffectView.addGestureRecognizer(tapGesture)
        view.insertSubview(blurEffectView, at: 0)
        
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        dismissButton.layer.cornerRadius = dismissButton.frame.height * 0.5
        dismissButton.layer.setFoodlyCustomShadow()
        
        decreaseQuantityButton.layer.cornerRadius = decreaseQuantityButton.frame.height * 0.5
        decreaseQuantityButton.layer.setFoodlyCustomShadow()
        
        increaseQuantityButton.layer.cornerRadius = increaseQuantityButton.frame.height * 0.5
        increaseQuantityButton.layer.setFoodlyCustomShadow()
        
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height * 0.5
        addToCartButton.layer.setFoodlyCustomShadow()
    }
}

// MARK: Helpers

private extension AddToCartViewController {
    
    func showContent() {
        UIView.animate(withDuration: animationDuration) {
            self.blurEffectView.alpha = 1.0
            self.containerView.transform = .identity
        }
    }
    
    func hideContent(withAnimation: Bool, completion: (() -> ())?) {
        let timeInterval = withAnimation ? animationDuration : 0.0

        UIView.animate(withDuration: timeInterval, animations: {
            self.blurEffectView.alpha = 0.0
            self.containerView.transform = CGAffineTransform(translationX: 0,
                                                             y: self.view.bounds.maxY)
        }) { (_) in
            completion?()
        }
    }
    
    @objc func dismissView() {
        hideContent(withAnimation: true) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func setTotalPrice() {
        let totalPrice = quantityOfItem * menuItem.price
        self.totalPriceLabel.text = "\(quantityOfItem) för \(totalPrice) kr"
    }
    
    func quantityDidChange() {
        decreaseQuantityButton.isUserInteractionEnabled = quantityOfItem > 1
        setTotalPrice()
    }
}
