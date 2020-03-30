//
//  LocationsSingleton.swift
//  OntheMap
//
//  Created by Osmar Hernández on 28/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct LocationsSingleton {
    static var shared = LocationsSingleton()
    
    var locations = [StudentLocation]()
}
