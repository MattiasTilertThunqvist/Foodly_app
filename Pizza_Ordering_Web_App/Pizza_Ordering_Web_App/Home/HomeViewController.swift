//
//  ViewController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-01-29.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    let dataController = DataController()
    let locationManager = CLLocationManager()
    var restaurants: [Restaurant] = []
    let cellIdentifier = "RestaurantTableViewCell"
    let dispatchGroup = DispatchGroup()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRequests()
        setup()
        setupTableView()
    }
}

// MARK: Setup

private extension HomeViewController {
    
    func setup() {
        
        
    }
    
    func startRequests() {
        checkLocationManager()
        getRestaurants()
        
        dispatchGroup.notify(queue: .main) {
            guard let location = self.locationManager.location else { return }
            self.restaurants.sort(by: { (restaurant1, restaurant2) -> Bool in
                return restaurant1.distance(to: location) < restaurant2.distance(to: location)
            })
            
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func getRestaurants() {
        dispatchGroup.enter()
        dataController.getRestaurants { (restaurants, error) in
            guard let restaurants = restaurants, error == nil else {
                // TODO: Handle error
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RestaurantTableViewCell
        cell.setName(name: restaurant.name)
        cell.setAdress(adress1: restaurant.address1, adress2: restaurant.address2)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

// MARK: Location

extension HomeViewController: CLLocationManagerDelegate {
    
    func checkLocationManager() {
        // If coordinante permission is denied then the dispatchGroup will never be nitified.
        dispatchGroup.enter()
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn location on
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert letting them know whats up.
            break
        case .authorizedAlways:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // When the user is allow sharing the position for the first time,checkLocationAuthorization() need to be called again in order to handle the users answer.
        checkLocationAuthorization()
        
        if status == .authorizedWhenInUse {
            dispatchGroup.leave()
        }
    }
}
