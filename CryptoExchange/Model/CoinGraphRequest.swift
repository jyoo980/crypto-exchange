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
    
    private var graphRequest = "https://min-api.cryptocompare.com/data/histohour?fsym={CRYPTO}&tsym={REAL}&limit={LIMIT}&toTs={TIME}"
    private let NUM_DATAPOINTS = "60"
    
    func getUpdatedChartData(crypto: String, real: String, chartView: LineChartView!) {
        self.constructDataPoints(crypto: crypto, real: real, chart: chartView)
    }
    
    fileprivate func generateRequestURL(cryptoCurrency: String, realCurrency: String) -> URL? {
        let currentUNIXTime = unixTime()
        var requestURL = self.graphRequest.replacingOccurrences(of: "{CRYPTO}", with: cryptoCurrency)
        requestURL = requestURL.replacingOccurrences(of: "{REAL}", with: realCurrency)
        requestURL = requestURL.replacingOccurrences(of: "{LIMIT}", with: NUM_DATAPOINTS)
        requestURL = requestURL.replacingOccurrences(of: "{TIME}", with: currentUNIXTime)
        return URL(string: requestURL)
    }
    
    fileprivate func unixTime() -> String {
        var unixTime = NSDate().timeIntervalSince1970.description
        if let dotRange = unixTime.range(of: ".") {
            unixTime.removeSubrange(dotRange.lowerBound..<unixTime.endIndex)
        }
        return unixTime
    }
    
    fileprivate func setGraph(_ dataSet: LineChartDataSet, _ chart: LineChartView!) {
        let data = LineChartData()
        data.addDataSet(dataSet)
        chart.data = data
        chart.animate(xAxisDuration: 1)
    }
    
    fileprivate func dispatchRequest(_ crypto: String, _ realCurrency: String, _ chart: LineChartView!) {
        getHistory(crypto: crypto, real: realCurrency) { (result) -> () in
            let dataSet = self.constructDataSet(history: result)
            GraphDataCache.shared.set(cryptoCurrency: crypto, realCurrency: realCurrency, data: dataSet)
            self.setGraph(dataSet, chart)
        }
    }
    
    fileprivate func constructDataPoints(crypto: String, real: String, chart: LineChartView!) {
        let dataCache = GraphDataCache.shared
        if dataCache.isDataSetPresent(cryptoCurrency: crypto, realCurrency: real) {
            let dataSet = dataCache.fetch(cryptoCurrency: crypto, realCurrency: real)
            self.setGraph(dataSet, chart)
        } else {
            dispatchRequest(crypto, real, chart)
        }
    }
    
    fileprivate func getHistory(crypto: String, real: String,  completionHandler: @escaping (_ result:NSArray) ->()) {
        let session = URLSession.shared
        let queryURL = generateRequestURL(cryptoCurrency: crypto, realCurrency: real)
        
        let dataTask = session.dataTask(with: queryURL!) { (data, response, error) in
            
            if let data = data {
                DispatchQueue.main.async {
                    let responseDict = dataToDict(data: data)
                    completionHandler(responseDict??["Data"] as! NSArray)
                }
            }
        }
        dataTask.resume()
    }
    
    fileprivate func constructDataSet(history: NSArray) -> LineChartDataSet {
        var lineChartData = [ChartDataEntry]()
        
        for d in 0...Int(NUM_DATAPOINTS)! {
            lineChartData.append(addDataPoint(history: history, day: d, year: Int(NUM_DATAPOINTS)!))
        }
        
        let dataSet = generateLineChartDataSet(line: lineChartData, label: "")
        return dataSet
    }
    
    fileprivate func addDataPoint(history: NSArray, day: Int, year: Int) -> ChartDataEntry {
        let coinEntry = history[year - day] as? NSDictionary
        let yVal = coinEntry?.value(forKey: "high")
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
