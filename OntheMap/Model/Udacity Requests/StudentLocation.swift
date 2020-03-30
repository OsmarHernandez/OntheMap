//
//  StudentLocation.swift
//  OntheMap
//
//  Created by Osmar Hernández on 27/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
