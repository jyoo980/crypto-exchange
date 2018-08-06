//
//  InfoViewUtility.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-08-06.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

func parseResponse(responseDict: NSArray??) -> [String:String] {
    var parsedData = [String:String]()
    let coinDict = responseDict!![0] as! NSDictionary
    let hourChange = parseHourChange(dict: coinDict)
    let dayChange = parseDayChange(dict: coinDict)
    let weekChange = parseWeekChange(dict: coinDict)
    parsedData["hourChange"] = hourChange
    parsedData["dayChange"] = dayChange
    parsedData["weekChange"] = weekChange
    return parsedData
}

func parseHourChange(dict: NSDictionary??) -> String {
    let hourChange = dict??.value(forKey: "percent_change_1h") as! String
    if hourChange != "" {
        return "Hour: " + addPcntSymbol(changeInRate: hourChange)
    } else {
        return "No data"
    }
}

func parseDayChange(dict: NSDictionary??) -> String {
    let dayChange = dict??.value(forKey: "percent_change_24h") as! String
    if dayChange != "" {
        return "Day: " + addPcntSymbol(changeInRate: dayChange)
    } else {
        return "No data"
    }
}

func parseWeekChange(dict: NSDictionary??) -> String {
    let weekChange = dict??.value(forKey: "percent_change_7d") as! String
    if weekChange != "" {
        return "Week: " + addPcntSymbol(changeInRate: weekChange)
    } else {
        return "No data"
    }
}

func addPcntSymbol(changeInRate: String) -> String {
    var finalRateString = changeInRate
    finalRateString = (finalRateString.contains("-")) ? changeInRate + "%" + " ↓" : changeInRate + "%" + " ↑"
    return finalRateString
}
