//
//  Model.swift
//  Todoey
//
//  Created by Bryan Heshiki on 12/24/17.
//  Copyright © 2017 Bryan Heshiki. All rights reserved.
//

import Foundation

class Item: Codable {
    
    var title : String = ""
    var done : Bool = false
}
