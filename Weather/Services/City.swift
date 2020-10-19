//
//  City.swift
//  Weather
//
//  Created by Ekaterina on 18.10.20.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import Foundation
import RealmSwift


class City: Object {
    @objc dynamic var name = ""
    let weathers = List<Weather>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

