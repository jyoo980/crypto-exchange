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
    @IBOutlet weak var dayChangeLabel: UILabel!
    @IBOutlet weak var weekChangeLabel: UILabel!
    
    private let apiClient = ApiClient()
    
    var currentCoin = ""
    var realCurrency = ""
    
    override func viewDidLoad() {
        self.coinLabel.text = currentCoin
        setInfoPeekData(cryptoCurrency: currentCoin, realCurrency: realCurrency)
    }
    
    fileprivate func setInfoPeekData(cryptoCurrency: String, realCurrency: String) {
        apiClient.getPopViewInfo(crypto: cryptoCurrency, currency: realCurrency) { result -> () in
            self.setInfoLabels(data: result)
        }
    }
    
    fileprivate func setInfoLabels(data: [String:String]) {
        DispatchQueue.main.async {
            self.hourChangeLabel.text = data["hourChange"]
            self.dayChangeLabel.text = data["dayChange"]
            self.weekChangeLabel.text = data["weekChange"]
        }
    }

}
        



