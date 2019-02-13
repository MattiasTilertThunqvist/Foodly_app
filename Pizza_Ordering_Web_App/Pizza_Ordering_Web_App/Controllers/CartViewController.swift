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
    
    // MARK: IBOutlets
    
    
    
    // Mark: IBAction
    
    
    
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: Setup

extension CartViewController {
    
    func setup() {
        title = "Varukorg"
        
    }
}
