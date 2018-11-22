//
//  RateTableViewCell.swift
//  ExchangeRates
//
//  Created by Tima on 21.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class RateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var charCodeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var scaleLabel: UILabel!
    
    var currency: Currency? {
        didSet {
            DispatchQueue.main.async {
                self.charCodeLabel.text = self.currency?.charCode
                if let rate = self.currency?.rate, let scale = self.currency?.scale, let name = self.currency?.name {
                    self.rateLabel.text = "\(rate) BYN"
                    self.scaleLabel.text = "\(scale) \(name) за 1 ед."
                }
                
                self.contentView.setGradient()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
