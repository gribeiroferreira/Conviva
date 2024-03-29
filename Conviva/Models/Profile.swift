//
//  Profile.swift
//  Conviva
//
//  Created by Gabriel Ferreira on 11/11/19.
//  Copyright © 2019 Gabriel Ferreira. All rights reserved.
//

import Foundation

class Profile: Codable {
    var id: Int?
    var name : String?
    var email : String?
    var password : String?
    var contact : String?
    var address : String?
    var description : String?
    var latitude: Double?
    var longitude: Double?
    var radius: Double?
    
//    
//    var managedEvents : [Event]?
//    var interestedEvents : [Event]?
//    
//    var helpItems : [Item]?
    
    init(id: Int, name: String, email: String, password: String, contact: String, address: String, description: String, latitude: Double, longitude: Double, radius: Double) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.contact = contact
        self.address = address
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }
    
    init(name: String, email: String, password: String, contact: String, address: String, description: String, latitude: Double, longitude: Double, radius: Double) {
        self.name = name
        self.email = email
        self.password = password
        self.contact = contact
        self.address = address
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }
    
    init() {
        
    }
}
