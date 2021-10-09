//
//  User.swift
//  YOUP
//
//  Created by Robert Miller on 09.10.2021.
//

import Foundation

class User {
    var username = ""
    var name = ""
    var surname = ""
    var password = ""
    private var email = ""

    var fullname: String {
        name + surname
    }
    
    var comments:[Comment] = []
}
