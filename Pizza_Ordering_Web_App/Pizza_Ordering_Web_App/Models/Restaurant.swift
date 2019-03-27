//
//  Restaurant.swift
//  Pizza_Ordering_Web_App
//
//  Created by Mattias Tilert Thunqvist on 2019-01-30.
//  Copyright © 2019 Mattias Tilert Thunqvist. All rights reserved.
//

import Foundation
import CoreLocation

struct Restaurant: Decodable {
    
    // MARK: Properties
    
    let id: Int
    let name: String
    let address1: String
    let address2: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    // MARK: Helpers
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}
