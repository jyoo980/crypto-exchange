//
//  InfoPopViewController.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-22.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation
import UIKit

class InfoPopViewController: UIViewController {
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var poundLabel: UILabel!
    @IBOutlet weak var yenLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    
    var currentCoin = ""
    var cdn = ""
    var eur = ""
    var yen = ""
    var usd = ""
    var pound = ""
    
    override func viewDidLoad() {
        coinLabel.text = "1 " + currentCoin
        cadLabel.text = cdn
        eurLabel.text = eur
        poundLabel.text = pound
        yenLabel.text = yen
        usdLabel.text = usd
    }
    
}
