//
//  Connectivity.swift
//  ExchangeRates
//
//  Created by Tima on 22.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import Alamofire

class Connectivity: NSObject {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
