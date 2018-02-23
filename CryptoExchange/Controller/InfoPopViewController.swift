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
    @IBOutlet var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    var currentCoin = ""
    
    override func viewDidLoad() {
        coinLabel.text = currentCoin
    }
    

}
