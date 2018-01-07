//
//  Category.swift
//  Todoey
//
//  Created by Bryan Heshiki on 1/3/18.
//  Copyright © 2018 Bryan Heshiki. All rights reserved.
//

import Foundation
import RealmSwift

//Object is a class used to define Realm objects
class Category: Object {
    
    @objc dynamic var name : String = ""
                //each category can have a list of items
    let items = List<Item>()
}
