//
//  Category.swift
//  Notes
//
//  Created by Ivan Nikitin on 10/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
