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
    
    private let apiClient = ApiClient()
    private let NUM_DATAPOINTS = "60"
    
    func getUpdatedChartData(crypto: String, real: String, chartView: LineChartView!) {
        self.constructDataPoints(crypto: crypto, real: real, chart: chartView)
    }
    
    private func setGraph(_ dataSet: LineChartDataSet, _ chart: LineChartView!) {
        let data = LineChartData()
        data.addDataSet(dataSet)
        chart.data = data
        chart.animate(xAxisDuration: 1)
    }
    
    private func dispatchRequest(_ crypto: String, _ realCurrency: String, _ chart: LineChartView!) {
        apiClient.getExchangeRateHistory(crypto: crypto, currency: realCurrency) { (result) -> () in
            let dataSet = self.constructDataSet(history: result)
            GraphDataCache.shared.set(cryptoCurrency: crypto, realCurrency: realCurrency, data: dataSet)
            self.setGraph(dataSet, chart)
        }
    }
    
    private func constructDataPoints(crypto: String, real: String, chart: LineChartView!) {
        let dataCache = GraphDataCache.shared
        if dataCache.isDataSetPresent(cryptoCurrency: crypto, realCurrency: real) {
            let dataSet = dataCache.fetch(cryptoCurrency: crypto, realCurrency: real)
            print("using cache")
            self.setGraph(dataSet, chart)
        } else {
            dispatchRequest(crypto, real, chart)
        }
    }
    
    private func constructDataSet(history: NSArray) -> LineChartDataSet {
        var lineChartData = [ChartDataEntry]()
        
        for d in 0...Int(NUM_DATAPOINTS)! {
            lineChartData.append(addDataPoint(history: history, day: d, year: Int(NUM_DATAPOINTS)!))
        }
        
        let dataSet = generateLineChartDataSet(line: lineChartData, label: "")
        return dataSet
    }
    
    private func addDataPoint(history: NSArray, day: Int, year: Int) -> ChartDataEntry {
        let coinEntry = history[year - day] as? NSDictionary
        let yVal = coinEntry?.value(forKey: "high")
        return ChartDataEntry(x: Double(day), y: yVal as! Double)
    }
    
    private func generateLineChartDataSet(line: [ChartDataEntry], label: String) -> LineChartDataSet {
        let line = LineChartDataSet(values: line, label: label)
        line.colors = [NSUIColor.black]
        line.drawCirclesEnabled = false
        line.drawValuesEnabled = false
        line.colors = [NSUIColor.orange]
        line.lineWidth = 2.0
        return line
    }

}
