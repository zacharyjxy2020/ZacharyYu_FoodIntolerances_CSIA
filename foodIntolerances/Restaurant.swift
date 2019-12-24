//
//  Restaurant.swift
//  foodIntolerances
//
//  Created by Zachary Yu on 26/9/2019.
//  Copyright © 2019 Zachary Yu. All rights reserved.
//

import Foundation

class Restaurant {
    
    var name:String = ""
    var address:String = ""
    var lat:Double = 0.0
    var lon:Double = 0.0
    var rating:Double = 0.0
    
    init(name:String, address:String,lat:Double,lon:Double, rating:Double) {
        self.name = name
        self.address = address
        self.lat = lat
        self.lon = lon
        self.rating = rating
    }
}
extension Restaurant:Equatable{
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.name == rhs.name
    }
    
}
