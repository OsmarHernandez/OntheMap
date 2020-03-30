//
//  UdacityResponse.swift
//  OntheMap
//
//  Created by Osmar Hernández on 28/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct CreateResponse: Codable {
    let createdAt: String
    let objectId: String
}

struct UpdateResponse: Codable {
    let updatedAt: String
}
