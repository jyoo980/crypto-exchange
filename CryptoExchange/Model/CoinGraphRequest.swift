//
//  GraphRequest.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-15.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation
import Charts

class CoinGraphRequest {
    
    private var graphRequest = "https://coinbin.org/{CRYPTO}/history"
    var chartData = LineChartData()
            
    func getUpdatedChartData(crypto: String, chartView: LineChartView!) {
        self.constructDataPoints(crypto: crypto, chart: chartView)
    }
    
    fileprivate func generateRequestURL(cryptoCurrency: String) -> URL? {
        let requestURL = self.graphRequest.replacingOccurrences(of: "{CRYPTO}", with: cryptoCurrency)
        return URL(string: requestURL)
    }
    
    fileprivate func constructDataPoints(crypto: String, chart: LineChartView!) {
        getHistory(crypto: crypto) { (result) -> () in
            let dataSet = self.constructDataSet(history: result)
            let data = LineChartData()
                data.addDataSet(dataSet)
                chart.data = data
        }
    }
    
    fileprivate func getHistory(crypto: String, completionHandler: @escaping (_ result:NSArray) ->()) {
        let session = URLSession.shared
        let queryURL = generateRequestURL(cryptoCurrency: crypto)
        
        let dataTask = session.dataTask(with: queryURL!) { (data, response, error) in
            
            if let data = data {
                DispatchQueue.main.async {
                    let responseDict = dataToDict(data: data)
                    completionHandler(responseDict??["history"] as! NSArray)
                }
            }
        }
        dataTask.resume()
    }
    
    fileprivate func constructDataSet(history: NSArray) -> LineChartDataSet {
        let year = setMaxIter(array: history)
        var lineChartData = [ChartDataEntry]()
        
        for d in 0...year {
            lineChartData.append(addDataPoint(history: history, day: d, year: year))
        }
        
        let dataSet = generateLineChartDataSet(line: lineChartData, label: "")
        return dataSet
    }
    
    fileprivate func setMaxIter(array: NSArray) -> Int {
        if (array.count < 365) {
            return array.count - 1
        } else {
            return 365
        }
    }
    
    fileprivate func addDataPoint(history: NSArray, day: Int, year: Int) -> ChartDataEntry {
        let coinEntry = history[year - day] as? NSDictionary
        let yVal = coinEntry?.value(forKey: "value")
        return ChartDataEntry(x: Double(day), y: yVal as! Double)
    }
    
    fileprivate func generateLineChartDataSet(line: [ChartDataEntry], label: String) -> LineChartDataSet {
        let line = LineChartDataSet(values: line, label: label)
        line.colors = [NSUIColor.black]
        line.drawCirclesEnabled = false
        line.drawValuesEnabled = false
        line.colors = [NSUIColor.orange]
        line.lineWidth = 2.0
        
        return line
    }

}
