//
//  Item.swift
//  Todoey
//
//  Created by CASE on 4/25/19.
//  Copyright © 2019 CASE. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var color : String = ""
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "Items")
}

