//
//  CryptoGraphView.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-16.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation
import Charts

class CryptoGraphView {
    
    func initChart(chart: LineChartView!) {
        chart.noDataText = ""
        chart.chartDescription?.text = ""
        chart.legend.enabled = false
        setXAxis(chart: chart)
        setLeftAxis(chart: chart)
        setRightAxis(chart: chart)
    }
    
    fileprivate func setXAxis(chart: LineChartView!) {
        chart.xAxis.drawLabelsEnabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawAxisLineEnabled = false
    }
    
    fileprivate func setLeftAxis(chart: LineChartView!) {
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
    }
    
    fileprivate func setRightAxis(chart: LineChartView!) {
        chart.rightAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
    }
    
    fileprivate func setGraphOptions(chart: LineChartView!) {
        chart.animate(xAxisDuration: 3000)
    }
    
}
