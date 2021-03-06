//
//  ViewController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-01-29.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantsViewController: UIViewController {
    
    // MARK: Properties
    
    let locationManager = CLLocationManager()
    var restaurants: [Restaurant] = []
    let RestaurantCellIdentifier = "RestaurantTableViewCell"
    let dispatchGroup = DispatchGroup()
    var locationIsNotSet = true
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func ordersButtonWasPressed(_ sender: UIButton) {
        presentOrders()
    }
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRequests()
        setup()
        setupTableView()
        registerNibs()
    }
}

// MARK: Setup

private extension RestaurantsViewController {
    
    func setup() {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = .pizzaColor(.white)
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.pizzaColor(.white),
                                    NSAttributedString.Key.font: UIFont.pizzaRegularFont(withSize: 20)]
        title = "Restauranger"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func startRequests() {
        checkLocationManager()
        getRestaurants()
        
        dispatchGroup.notify(queue: .main) {
            if let location = self.locationManager.location, !self.restaurants.isEmpty {
                self.restaurants.sort(by: { (restaurant1, restaurant2) -> Bool in
                    return restaurant1.distance(to: location) < restaurant2.distance(to: location)
                })
                
                self.tableView.reloadData()
            }
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    func registerNibs() {
        let cellNib = UINib(nibName: RestaurantCellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: RestaurantCellIdentifier)
    }
    
    func getRestaurants() {
        dispatchGroup.enter()
        DataController.sharedInstance.getRestaurants { (restaurants, error) in
            if error != nil {
                self.presentErrorAlert(title: "Kunde inte hämta restauranger", message: "", buttonText: "Okej")
            } else if let restaurants = restaurants {
                self.restaurants = restaurants
            }
            
            self.dispatchGroup.leave()
        }
    }
}

// MARK: TableView

extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restaurants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCellIdentifier) as! RestaurantTableViewCell
        cell.setName(to: restaurant.name)
        cell.setAdress(to: restaurant.address1 + ", " + restaurant.address2)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = StoryboardInstance.home
        if let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            viewController.restaurant = restaurants[indexPath.row]
            viewController.dismissProtocol = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: Location

extension RestaurantsViewController: CLLocationManagerDelegate {
    
    func checkLocationManager() {
        dispatchGroup.enter()
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            presentErrorAlert(title: "Platsdata avstängt", message: "Gå till inställningar och aktivera platsdata.", buttonText: "Okej")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            presentErrorAlert(title: "Kan ej hämta platsdata", message: "Gå till inställningar och tillåt appen åtkomst av platsdata.", buttonText: "Okej")
            break
        case .restricted:
            presentErrorAlert(title: "Kan ej hämta platsdata", message: "För att använda appen krävs åtkomst av platsdata.", buttonText: "Okej")
            break
        case .authorizedWhenInUse:
            if locationIsNotSet {
                dispatchGroup.leave()
                locationIsNotSet.toggle()
            }
            break
        case .authorizedAlways:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

// MARK: Helper

private extension RestaurantsViewController {
    
    func presentOrders() {
        if let viewController = StoryboardInstance.home.instantiateViewController(withIdentifier: "OrderOverviewViewController") as? OrderOverviewViewController {
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

extension RestaurantsViewController: DismissProtocol {
    func dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
}
