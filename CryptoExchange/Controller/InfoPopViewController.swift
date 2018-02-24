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
    @IBOutlet weak var hourChangeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var currentCoin = ""
    var realCurrency = ""
    
    override func viewDidLoad() {
        self.coinLabel.text = currentCoin
    }
    
    fileprivate func setInfoPeekData(cryptoCurrency: String, realCurrency: String) {
        let popViewRequest = InfoPopViewRequest()
        popViewRequest.getReponseData(crypto: currentCoin, country: realCurrency) { (result) in
            self.sethourChangeLabel(hourDiff: result["hourChange"]!)
            self.setvolumeLabel(volume: result["volume"]!)
            self.settimeStampLabel(timeStamp: result["timeStamp"]!)
        }
    }
    
    fileprivate func sethourChangeLabel(hourDiff: String) {
        // TODO
    }
    
    fileprivate func setvolumeLabel(volume: String) {
        // TODO
    }
    
    fileprivate func settimeStampLabel(timeStamp: String) {
        // TODO
    }
    
}
