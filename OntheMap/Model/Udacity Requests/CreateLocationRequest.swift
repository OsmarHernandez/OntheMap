//
//  CreateLocationRequest.swift
//  OntheMap
//
//  Created by Osmar Hernández on 30/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct CreateLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    init(dictionary: [String : Any]) {
        self.uniqueKey = dictionary["uniqueKey"] as! String
        self.firstName = dictionary["firstName"] as! String
        self.lastName = dictionary["lastName"] as! String
        self.mapString = dictionary["mapString"] as! String
        self.mediaURL = dictionary["mediaURL"] as! String
        self.latitude = dictionary["latitude"] as! Double
        self.longitude = dictionary["longitude"] as! Double
    }
}
