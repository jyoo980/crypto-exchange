//
//  CryptoPickerView.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-16.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CrypoPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let pickerValues = [["BCH", "BTC", "BTG", "ETH", "LTC", "XRP"],
                        ["CAD", "USD", "GBP", "EUR", "JPY"]]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent
        component: Int) -> String? {
        return pickerValues[component][row]
    }
    
    func getSelectedCrypto() -> String {
        let crypoChoiceIndex = selectedRow(inComponent: 0)
        return self.pickerValues[0][crypoChoiceIndex]
    }
    
    func getSelectedReal() -> String {
        let currencyChoiceIndex = selectedRow(inComponent: 1)
        return self.pickerValues[1][currencyChoiceIndex]
    }
    
    
   

    
    
}



