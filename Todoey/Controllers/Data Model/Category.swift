//
//  Category.swift
//  Todoey
//
//  Created by CASE on 4/25/19.
//  Copyright © 2019 CASE. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let Items = List<Item>()
}
