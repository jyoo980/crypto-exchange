//
//  ViewController.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-11.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var conversionText: UILabel!
    @IBOutlet weak var cryptoPicker: UIPickerView!
    
    let request = "https://rest.coinapi.io/v1/exchangerate/{CRPTO}/{REAL}?apikey={APIKEY}"
    let pickerValues = [["BCH", "BTC", "BTG", "ETH", "LTC", "XRP"],
                           ["CAD", "USD", "GBP"]]
    let callExceedMessage = "API Calls Exceeded"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cryptoPicker.delegate = self
        cryptoPicker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        getConversionRate(crypto: "BTC", realCurrency: "USD")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        let selectedCrypto = getSelectedCrypto()
        let selectedReal = getSelectedReal()
        getConversionRate(crypto: selectedCrypto, realCurrency: selectedReal)
    }
    
    func getSelectedCrypto() -> String {
        let cryptoChoiceIndex = cryptoPicker.selectedRow(inComponent: 0)
        return pickerValues[0][cryptoChoiceIndex]
    }
    
    func getSelectedReal() -> String {
        let currencyChoiceIndex = cryptoPicker.selectedRow(inComponent: 1)
        return pickerValues[1][currencyChoiceIndex]
    }
    
    // Number of rows in our pickerViw
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent
        component: Int) -> String? {
        return pickerValues[component][row]
    }
    
    fileprivate func printReponse(data: Data?) {
        let responseString = String(data: data!, encoding: String.Encoding.utf8)
        print("Conversion Rate Data:\n\(responseString!)")
    }
    
    fileprivate func getRequestURL(crypoCurrency: String, countryCurrency: String)-> URL? {
        var requestURL = self.request.replacingOccurrences(of: "{CRPTO}", with: crypoCurrency)
        requestURL = requestURL.replacingOccurrences(of: "{REAL}", with: countryCurrency)
        return URL(string: requestURL)
    }
    
    fileprivate func getJSONDict(data: Data?) -> NSDictionary?? {
        return try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
    }
    
    fileprivate func setErrorLabel() {
        DispatchQueue.main.async {
            self.conversionText.text = self.callExceedMessage
        }
    }
    
    fileprivate func setConverstionLabel(_ responseDict: NSDictionary??) {
        DispatchQueue.main.async {
            let crypto = responseDict??.value(forKey: "asset_id_base") as! String
            let realWorld = responseDict??.value(forKey: "asset_id_quote") as! String
            let cryptoCost = responseDict??.value(forKey: "rate") as! NSDecimalNumber
            let costAsDouble = cryptoCost.doubleValue
            let costAsString = String(round(100*costAsDouble)/100)
            self.conversionText.text = "1 " + "\(crypto)" + " = " + "\(costAsString)" + " \(realWorld)"
        }
    }
    
    func getConversionRate(crypto: String, realCurrency: String) {
        let session = URLSession.shared
        let queryURL = getRequestURL(crypoCurrency: crypto, countryCurrency: realCurrency)
        
        let dataTask = session.dataTask(with: queryURL!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let data = data {
                // Printing JSON Response to console
                self.printReponse(data: data)
                let responseDict = self.getJSONDict(data: data)
                if responseDict??["error"] != nil {
                    self.setErrorLabel();
                } else{
                    self.setConverstionLabel(responseDict)
                }
            }
        }
        dataTask.resume()
    }
}
