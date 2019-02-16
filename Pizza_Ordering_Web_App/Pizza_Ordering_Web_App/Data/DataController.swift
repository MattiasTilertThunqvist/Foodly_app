//
//  DataController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-01-30.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

class DataController {
    static let sharedInstance = DataController()
    var restaurants: [Restaurant] = []
    var menu: [MenuItem] = []
    var orderStatus: [OrderStatus] = []
    
    private init() {}
    
    func getRestaurants(completion: @escaping (_ restaurants: [Restaurant]?, _ error: Error?) -> ()) {
        let url = URL(string: "https://private-anon-93a88b892d-pizzaapp.apiary-mock.com/restaurants/")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                    self.restaurants = restaurants
                    completion(restaurants, nil)
                } catch let jsonError {
                    completion(nil, jsonError)
                }
            } else {
                completion(nil, error)
            }
        }.resume()
    }
    
    func getMenuForRestaurant(with id: Int, completion: @escaping (_ menu: [MenuItem]?, _ error: Error?) -> ()) {
        let url = URL(string: "https://private-anon-aaa547a087-pizzaapp.apiary-mock.com/restaurants/\(id)/menu")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let menu = try JSONDecoder().decode([MenuItem].self, from: data)
                    self.menu = menu
                    completion(menu, nil)
                } catch let jsonError {
                    completion(nil, jsonError)
                }
            } else {
                completion(nil, error)
            }
        }.resume()
    }
    
    func createOrder(_ order: Order, completion: @escaping (_ orderStatus: OrderStatus?, _ error: Error?) -> ()) {
        let url = URL(string: "https://private-anon-bc43a7f805-pizzaapp.apiary-mock.com/orders/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(order)
            request.httpBody = jsonData
        } catch {
            completion(nil, error)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil, let data = data {
                do {
                    var orderStatus = try JSONDecoder().decode(OrderStatus.self, from: data)
                    orderStatus.cart = order.cart
                    orderStatus.restuarantId = order.restuarantId
                    self.orderStatus.append(orderStatus)
                    completion(orderStatus, nil)
                } catch let jsonError {
                    completion(nil, jsonError)
                }
            }
        }.resume()
    }
}
