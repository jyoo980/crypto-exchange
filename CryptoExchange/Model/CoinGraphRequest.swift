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
    
    fileprivate func generateRequestURL(cryptoCurrency: String) -> URL? {
        let requestURL = self.graphRequest.replacingOccurrences(of: "{CRYPTO}", with: cryptoCurrency)
        return URL(string: requestURL)
    }
    
    func getHistory(crypto: String, completionHandler: @escaping (_ result:NSArray) ->()) {
        let session = URLSession.shared
        let queryURL = generateRequestURL(cryptoCurrency: crypto)
        
        let dataTask = session.dataTask(with: queryURL!) { (data, response, error) in
            
            if let data = data {
                
                let responseDict = self.parseToDict(responseData: data)
                completionHandler(responseDict??["history"] as! NSArray)
            }
        }
        dataTask.resume()
    }
    
    fileprivate func parseToDict(responseData: Data?) -> NSDictionary?? {
        return try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as! NSDictionary
    }
    
    fileprivate func retrieveGraphData(crypto: String) -> LineChartData {
        getHistory(crypto: crypto) { result -> () in
             var dataLine = self.constructDataPoints(history: result)
        
            return nil  //todo
        }
        
    }
    
    fileprivate func constructDataPoints(history: NSArray) -> LineChartData {
        var year = setMaxIter(array: history)
        var lineChartData = [ChartDataEntry]()
        
        for d in 0...year {
            lineChartData.append(addDataPoint(history: history, day: d, year: 365))
        }
        
        let line1 = LineChartDataSet(values: lineChartData, label: "")
        line1.colors = [NSUIColor.black]
        line1.drawCirclesEnabled = false
        line1.drawValuesEnabled = false
        line1.colors = [NSUIColor.orange]
        line1.lineWidth = 2.0
        let data = LineChartData()
        
        return data
    }
    
    fileprivate func addDataPoint(history: NSArray, day: Int, year: Int) -> ChartDataEntry {
        let coinEntry = history[year - day] as? NSDictionary
        let yVal = coinEntry?.value(forKey: "value")
        return ChartDataEntry(x: Double(day), y: yVal as! Double)
    }
    
    fileprivate func setMaxIter(array: NSArray) -> Int {
        if (array.count < 365) {
            return array.count - 1
        } else {
            return 365
        }
    }
    
    

}
