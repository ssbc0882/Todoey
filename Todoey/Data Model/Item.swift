//
//  Item.swift
//  Todoey
//
//  Created by Bryan Heshiki on 1/3/18.
//  Copyright © 2018 Bryan Heshiki. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {

    @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    //defining the list of items- linking the relationship between Item and Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
 
    
}

