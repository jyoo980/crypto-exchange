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
    
    let request = "https://rest.coinapi.io/v1/exchangerate/{CRPTO}/{REAL}?apikey=***REMOVED***"
    let pickerValues = [["BCH", "BTC", "BTG", "ETC", "LTC", "XRP", "ZEC"],
                           ["CAN", "USD", "GBP"]]
    
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
    
    // Number of rows in our pickerView
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
    
    fileprivate func setConverstionLabel(_ responseDict: NSDictionary??) {
        let crypto = responseDict??.value(forKey: "asset_id_base") as! String
        let realWorld = responseDict??.value(forKey: "asset_id_quote") as! String
        let crypoCost = responseDict??.value(forKey: "rate")
        self.conversionText.text = "1 " + "\(crypto)" + " = "
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
                DispatchQueue.main.async {
                    self.setConverstionLabel(responseDict)
                }
            }
        }
        dataTask.resume()
    }
}
