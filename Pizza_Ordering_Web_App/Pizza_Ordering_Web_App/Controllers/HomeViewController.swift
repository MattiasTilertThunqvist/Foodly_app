//
//  ViewController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-11-10.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    let locationManager = CLLocationManager()
    var restaurants: [Restaurant] = []
    let dispatchGroup = DispatchGroup()
    var locationAuthStatusIsSet = false
    
    // MARK: IBOutlets
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: IBActions
    
    @IBAction func ordersButtonWasPressed(_ sender: UIButton) {
        presentOrders()
    }
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        registerNibs()
        startRequests()
    }
}

// MARK: Setup

private extension HomeViewController {
    
    func setup() {
        title = "Restauranger"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func startRequests() {
        getRestaurants()
        checkLocationManager()
        
        dispatchGroup.notify(queue: .main) {
            if let location = self.locationManager.location {
                self.restaurants.sort(by: { (restaurant1, restaurant2) -> Bool in
                    return restaurant1.distance(to: location) < restaurant2.distance(to: location)
                })
            }
            
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 115
    }
    
    func registerNibs() {
        let identifier = RestaurantTableViewCell.reuseIdentifier()
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
    }
    
    func getRestaurants() {
        dispatchGroup.enter()
        DataController.getRestaurants { (restaurants, error) in
            guard let restaurants = restaurants, error == nil else {
                self.presentErrorAlert(title: "Kunde inte hämta restauranger", message: "", buttonText: "Okej")
                return
            }
            
            self.restaurants = restaurants
            self.dispatchGroup.leave()
        }
    }
}

// MARK: TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restaurants[indexPath.row]
        
        let identifier = RestaurantTableViewCell.reuseIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! RestaurantTableViewCell
        cell.selectionStyle = .none
        cell.setName(to: restaurant.name)
        cell.setAdress(adress1: restaurant.address1, address2: restaurant.address2)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = StoryboardInstance.home
        if let viewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
            viewController.restaurant = restaurants[indexPath.row]
            viewController.dismissProtocol = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: Location

extension HomeViewController: CLLocationManagerDelegate {
    
    func checkLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            dispatchGroup.enter()
            checkLocationAuthorization()
        } else {
            locationAuthStatusIsSet.toggle()
        }
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            if locationAuthStatusIsSet == false {
                locationAuthStatusIsSet.toggle()
                dispatchGroup.leave()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

// MARK: Helpers

private extension HomeViewController {
    
    func presentOrders() {
        if let viewController = StoryboardInstance.home.instantiateViewController(withIdentifier: "OrderOverviewViewController") as? OrderOverviewViewController {
            viewController.restaurants = restaurants
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func presentErrorAlert(title: String, message: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonText, style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: DismissProtocol

extension HomeViewController: DismissProtocol {
    func dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
}
