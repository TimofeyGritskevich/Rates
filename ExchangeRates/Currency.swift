//
//  Currency.swift
//  ExchangeRates
//
//  Created by Tima on 20.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Currency: Object {

    @objc dynamic var charCode = ""
    @objc dynamic var scale = ""
    @objc dynamic var name = ""
    @objc dynamic var rate = ""
    @objc dynamic var order = 0
    
    convenience init(charCode: String, scale: String, name: String, rate: String, order: Int) {
        self.init()
        self.charCode = charCode
        self.scale = scale
        self.name = name
        self.rate = rate
        self.order = order
    }    
}

