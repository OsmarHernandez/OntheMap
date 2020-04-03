//
//  Locations.swift
//  OntheMap
//
//  Created by Osmar Hernández on 26/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct Locations: Codable {
    static var shared = Locations()
    
    var results = [StudentLocation]()
}
