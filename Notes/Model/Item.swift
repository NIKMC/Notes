//
//  Item.swift
//  Notes
//
//  Created by Иван Никитин on 28/02/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
//instead using Encodable, Decodable we can use Codable
class Item : Codable {
    public var title : String = ""
    public var done : Bool = false
    
//    init(Title : String, checked : Bool) {
//        self.title = Title
//        self.done = checked
//    }
}
