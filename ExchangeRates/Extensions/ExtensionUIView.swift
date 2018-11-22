//
//  ExtensionUIView.swift
//  ExchangeRates
//
//  Created by Tima on 22.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor(red: 252/255, green: 228/255, blue: 3/255, alpha: 1).cgColor, UIColor.lightGray.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(gradient, at: 0)
    }
}
