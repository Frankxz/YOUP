//
//  User.swift
//  YOUP
//
//  Created by Robert Miller on 09.10.2021.
//

import Foundation
import Firebase
import FirebaseAuth

class YoupUser {
    var username = ""
    var name = ""
    var surname = ""
    var password = ""
    var imgName = " "
    private let id: String
    private let email: String

    var fullname: String {
        name + surname
    }
    
    var comments:[Comment] = []
    
    init(user: User){
        id = user.uid
        email = user.email!
    }
    
    init(name: String, surname: String, username: String, imgName: String){
        self.name = name
        self.surname = surname
        self.username = username
        self.imgName = imgName
        id = ""
        email = ""
    }
}
extension YoupUser {
    static func getUsersList() -> [YoupUser] {
        
        var users: [YoupUser] = []
        
        let names = DataManager.shared.names.shuffled()
        let usernames = DataManager.shared.usernames.shuffled()
        let surnames = DataManager.shared.surnames.shuffled()
        let imgNames = DataManager.shared.imgNames.shuffled()
    
        
        let iterationCount = min(names.count, surnames.count, usernames.count, imgNames.count)
        
        for index in 0..<iterationCount {
            let youpUser = YoupUser(
    
                name: names[index],
                surname: surnames[index],
                username: usernames[index],
                imgName: imgNames[index]
            )
            
            users.append(youpUser)
        }
        
        return users
    }
}
