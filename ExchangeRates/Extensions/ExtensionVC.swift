//
//  Extension.swift
//  ExchangeRates
//
//  Created by Tima on 22.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setConnectionProblemsAlert() {
        let alert = UIAlertController(title: "Сonnection problems.", message: "Check connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Some error.", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
