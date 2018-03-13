//
//  Item.swift
//  Notes
//
//  Created by Ivan Nikitin on 10/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateTime : Date?
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
