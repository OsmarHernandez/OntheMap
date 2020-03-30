//
//  UdacitySessionResponse.swift
//  OntheMap
//
//  Created by Osmar Hernández on 27/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct UdacitySessionResponse: Codable {
    let account: Account
    let session: Session
}
