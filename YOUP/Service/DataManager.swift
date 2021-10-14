//
//  DataManager.swift
//  YOUP
//
//  Created by Robert Miller on 12.10.2021.
//

import Foundation
import UIKit

class DataManager {
    static let shared = DataManager();
    private init() {}
    
    let personsCount =  10
    let names = ["Robert", "Jack", "Michael", "Alex", "Alice",
                 "Maria", "Ivan", "Leo", "Albert", "Zhan" ]
    
    let usernames = ["KekeBe", "Babkak", "Milinas", "Arisak", "Bagks",
                     "Markias", "Vanjs", "Leoka", "Berto", "Hansnam" ]
    
    let surnames = ["Miller", "Brown", "Black", "Banino", "Wheeldy",
                    "Bound", "Frizer", "Gandolfini", "Brioni", "Ramzi"]
    
    let imgNames = ["1","2","3","4","5","6","7","8","9","10"]
    
    
}
