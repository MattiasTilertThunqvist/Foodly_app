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
    var orders: [Order] = []
    
    func getRestaurants(completion: @escaping (_ restaurants: [Restaurant]?, _ error: Error?) -> ()) {
        let url = URL(string: "https://private-130ed-foodapp5.apiary-mock.com/restaurants/")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                self.restaurants = restaurants
                completion(restaurants, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
        }.resume()
    }
    
    func getMenuForRestaurant(with id: Int, completion: @escaping (_ menu: [MenuItem]?, _ error: Error?) -> ()) {
        // TODO: Andra så att listan sorteras redan vid anrop. APIet tillåter det.
        let url = URL(string: "https://private-130ed-foodapp5.apiary-mock.com/restaurants/\(id)/menu")!

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let menu = try JSONDecoder().decode([MenuItem].self, from: data)
                self.menu = menu
                completion(menu, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
        }.resume()
    }
    
    func createOrder(_ newOrder: NewOrder, completion: @escaping (_ order: Order?, _ error: Error?) -> ()) {
        let url = URL(string: "https://private-130ed-foodapp5.apiary-mock.com/orders/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(newOrder)
            request.httpBody = jsonData
        } catch {
            completion(nil, error)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                var order = try JSONDecoder().decode(Order.self, from: data)
                order.restuarantId = newOrder.restuarantId
                self.orders.insert(order, at: 0)
                completion(order, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
            }.resume()
    }
    
    func getOrder(withId id: Int, completion: @escaping (_ order: [Order], _ error: Error?) -> ()) {
        let url = URL(string: "https://private-130ed-foodapp5.apiary-mock.com/orders/\(id)")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion([], error)
                return
            }
            
            do {
                let order = try JSONDecoder().decode(Order.self, from: data)
                guard let index = self.orders.index(where: { $0.orderId == id }) else { return }
                
                if self.orders[index].esitmatedDelivery != order.esitmatedDelivery ||
                    self.orders[index].status != order.status {
                    
                    self.orders[index].esitmatedDelivery = order.esitmatedDelivery
                    self.orders[index].status = order.status
                    self.orders[index].cart = order.cart
                    completion(self.orders, nil)
                } else {
                    completion([], nil)
                }
            } catch let jsonError {
                completion([], jsonError)
            }
        }.resume()
    }
}
