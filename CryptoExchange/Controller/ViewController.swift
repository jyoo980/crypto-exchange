//
//  ViewController.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-11.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var conversionText: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var cryptoPicker: UIPickerView!
    let graphView = CryptoGraphView()
    let pickerValues = [["BCH", "BTC", "BTG", "ETH", "LTC", "XRP"], ["CAD", "USD", "GBP", "EUR", "JPY"]]
    let defaultMessage = "Select Below"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cryptoPicker.delegate = self
        cryptoPicker.dataSource = self
        self.graphView.initChart(chart: self.chartView)
        if self.conversionText.text != defaultMessage {
            self.displayDefault()
        }
    }
    
    func displayDefault() {
        self.conversionText.text = defaultMessage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        let selectedCrypto = getSelectedCrypto()
        let selectedReal = getSelectedReal()
        updateConversionRate(crypto: selectedCrypto, realCurrency: selectedReal)
        getExchangeRateGraph(coin: selectedCrypto)
    }
    
    func getSelectedCrypto() -> String {
        let cryptoChoiceIndex = cryptoPicker.selectedRow(inComponent: 0)
        return pickerValues[0][cryptoChoiceIndex]
    }
    
    func getSelectedReal() -> String {
        let currencyChoiceIndex = cryptoPicker.selectedRow(inComponent: 1)
        return pickerValues[1][currencyChoiceIndex]
    }
    
    fileprivate func getExchangeRateGraph(coin: String) {
        let coinGraphRequest = CoinGraphRequest()
        coinGraphRequest.getUpdatedChartData(crypto: coin, chartView: self.chartView)
    }
    
    func updateConversionRate(crypto: String, realCurrency: String) {
        let coinExchangeRequest = CoinExchangeRequest()
        coinExchangeRequest.getConversionRate(crypto: crypto, country: realCurrency) { (result) -> () in
            self.setExchangeRateLabel(rate: result)
        }
    }
    
    fileprivate func setExchangeRateLabel(rate: String) {
        DispatchQueue.main.async {
            self.conversionText.text = rate
        }
    }
    
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
    
}
