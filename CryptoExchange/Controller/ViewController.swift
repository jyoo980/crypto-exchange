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
    @IBOutlet weak var cryptoPicker: UIPickerView!
    @IBOutlet weak var chartView: LineChartView!
    
    let pickerValues = [["BCH", "BTC", "BTG", "ETH", "LTC", "XRP"],
                           ["CAD", "USD", "GBP", "EUR", "JPY"]]
    let callExceedMessage = "API Calls Exceeded"
    let defaultMessage = "Select Below"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cryptoPicker.delegate = self
        cryptoPicker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        self.initChart()
        if self.conversionText.text != "Select Below" {
            self.displayDefault()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        let selectedCrypto = getSelectedCrypto()
        let selectedReal = getSelectedReal()
        updateConversionRate(crypto: selectedCrypto, realCurrency: selectedReal)
//        getExchangeRateGraph(crypto: selectedCrypto)
    }
    
    func displayDefault() {
        self.conversionText.text = defaultMessage
    }
    
    func getSelectedCrypto() -> String {
        let cryptoChoiceIndex = cryptoPicker.selectedRow(inComponent: 0)
        return pickerValues[0][cryptoChoiceIndex]
    }
    
    func getSelectedReal() -> String {
        let currencyChoiceIndex = cryptoPicker.selectedRow(inComponent: 1)
        return pickerValues[1][currencyChoiceIndex]
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
    
    fileprivate func updateGraph(coinData: NSArray) {
        DispatchQueue.main.async {
            var year = 0;
            if (coinData.count < 365) {
                year = coinData.count - 1
            } else {
                year = 365
            }
            var lineChartDatum = [ChartDataEntry]()
            
            for d in 0...year {
                let coinEntry = coinData[year - d] as? NSDictionary
                let yVal = coinEntry?.value(forKey: "value")
                let value = ChartDataEntry(x: Double(d), y: yVal as! Double)
                lineChartDatum.append(value)
            }
            
            let line1 = LineChartDataSet(values: lineChartDatum, label: "")
            line1.colors = [NSUIColor.black]
            line1.drawCirclesEnabled = false
            line1.drawValuesEnabled = false
            line1.colors = [NSUIColor.orange]
            line1.lineWidth = 2.0
            let data = LineChartData()
            
            data.addDataSet(line1)
            self.chartView.data = data
        }
    }
    
    fileprivate func initChart() {
        self.chartView.noDataText = ""
        self.chartView.chartDescription?.text = ""
        self.chartView.xAxis.drawLabelsEnabled = false
        self.chartView.xAxis.drawGridLinesEnabled = false
        self.chartView.xAxis.drawAxisLineEnabled = false
        self.chartView.leftAxis.drawAxisLineEnabled = false
        self.chartView.leftAxis.drawLabelsEnabled = false
        self.chartView.leftAxis.drawGridLinesEnabled = false
        self.chartView.rightAxis.drawAxisLineEnabled = false
        self.chartView.rightAxis.drawLabelsEnabled = false
        self.chartView.rightAxis.drawGridLinesEnabled = false
        self.chartView.legend.enabled = false
    }
    
    //    func getExchangeRateGraph(crypto: String) {
    //        let session = URLSession.shared;
    //        let queryURL = getGraphRequestURL(coin: crypto)
    //
    //        let dataTask = session.dataTask(with: queryURL!) {
    //            (data: Data?, response: URLResponse?, error: Error?) in
    //
    //            if let data = data {
    //                // Printing JSON Response to console
    //                let responseDict = self.getJSONDict(data: data)
    //                let historyArray = responseDict??["history"] as! NSArray
    //                self.updateGraph(coinData: historyArray)
    //            }
    //        }
    //        dataTask.resume()
    //    }
    
    func setExchangeRateLabel(rate: String) {
        DispatchQueue.main.async {
            self.conversionText.text = rate
        }
    }
    
    func updateConversionRate(crypto: String, realCurrency: String) {
        let coinExchangeRequest = CoinExchangeRequest()
        coinExchangeRequest.getConversionRate(crypto: crypto, country: realCurrency) { (result) -> () in
            self.setExchangeRateLabel(rate: result)
        }
    }
    
}




