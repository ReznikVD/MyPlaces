//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by user207855 on 2/1/22.
//

import Foundation

struct Place {
    
    var name: String
    var location: String
    var type: String
    var image: String
    
    static private let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai",
        "X.O", "Sherlock Holmes", "Speak Easy"
    ]
    
    static func getPlaces() -> [Place] {
        
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Rostov", type: "Bar", image: place))
        }
        
        return places
    }
}
