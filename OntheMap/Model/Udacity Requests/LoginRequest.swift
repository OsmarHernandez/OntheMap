//
//  LoginRequest.swift
//  OntheMap
//
//  Created by Osmar Hernández on 27/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let udacity: User
}
