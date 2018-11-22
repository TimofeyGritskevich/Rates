//
//  Manager.swift
//  ExchangeRates
//
//  Created by Tima on 20.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Manager: NSObject {
    
    static var userDefaults = UserDefaults.standard
    static let urlString = "http://www.nbrb.by/Services/XmlExRates.aspx"
    static let realm = try! Realm()
    static var result: Results<Currency> {
        get {
            return realm.objects(Currency.self)
        }
    }
    
    static func saveDate(date: String) {
        userDefaults.set(date, forKey: "lastUpdateDate")
        userDefaults.synchronize()
    }
    
    static func loadDate() -> String {
        return userDefaults.object(forKey: "lastUpdateDate") as? String ?? "Последнее обновление"
    }
    
    static func saveRealm (rates: [Currency]) {
        try! Manager.realm.write {
            Manager.realm.add(rates)
        }
    }
    
    static func updateRates(rates: [Currency]) {  
        for item in rates {
            if let newRate = Manager.realm.objects(Currency.self).filter("charCode = %@", item.charCode).first {
                try! Manager.realm.write {
                    newRate.rate = item.rate
                }
            }
        }
    }
    
    static func setTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let updateTime = "Последнее обновление \(formatter.string(from: Date()))"
        saveDate(date: updateTime)
        return updateTime
    }
}
