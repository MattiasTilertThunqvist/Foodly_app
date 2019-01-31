//
//  DataController.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-01-30.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation

class DataController {
    
    func getRestaurants(completion: @escaping (_ restaurants: [Restaurant]?, _ error: Error?) -> ()) {
        guard let url = URL(string: "https://private-anon-93a88b892d-pizzaapp.apiary-mock.com/restaurants/") else { return } // TODO: Handle error
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                    completion(restaurants, nil)
                } catch let jsonError {
                    print(jsonError)
                    //TODO: Handle error
                }
            } else {
                print(error ?? "Unknown error")
                completion(nil, error)
            }
        }.resume()
    }
}
