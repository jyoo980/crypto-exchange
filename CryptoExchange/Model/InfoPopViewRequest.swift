//
//  InfoPopViewRequest.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-23.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class InfoPopViewRequest {
    
    private let request = "https://api.coinmarketcap.com/v1/ticker/{CRYPTO}/?convert={REAL}"
    private let cryptoDict = ["BCH":"bitcoin-cash", "BTC":"bitcoin", "BTG":"bitcoin-gold", "DOGE":"dogecoin", "ETH":"ethereum", "LTC":"litecoin", "XRP":"ripple"]
    private let REQUEST_ERROR = ["REQUEST_ERROR":"ERROR"]
    private let NO_DATA = "No data"
    
    func getReponseData(crypto: String, country: String, completionHandler: @escaping (_ result:[String:String]) ->()) {
        let session = URLSession.shared
        let requestURL = generateRequestURL(cryptoCurrency: crypto, realCurrency: country)
        
        let dataTask = session.dataTask(with: requestURL!) { (data, response, error) in
            
            if let data = data {
                let responseDict = dataToJSONArray(data: data)
                if responseDict != nil {
                    completionHandler(self.parseResponse(responseDict: responseDict))
                } else {
                    completionHandler(self.REQUEST_ERROR)
                }
            }
        }
        dataTask.resume()
    }
    
    fileprivate func generateRequestURL(cryptoCurrency: String, realCurrency: String) -> URL? {
        let coin = self.cryptoDict[cryptoCurrency]
        var requestURL = self.request.replacingOccurrences(of: "{CRYPTO}", with: coin!)
        requestURL = requestURL.replacingOccurrences(of: "{REAL}", with: realCurrency)
        return URL(string: requestURL)
    }
    
    fileprivate func parseResponse(responseDict: NSArray??) -> [String:String] {
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
    
    fileprivate func parseHourChange(dict: NSDictionary??) -> String {
        let hourChange = dict??.value(forKey: "percent_change_1h") as! String
        if hourChange != "" {
            return "Hour: " + hourChange + "%"
        } else {
            return NO_DATA
        }
    }
    
    fileprivate func parseDayChange(dict: NSDictionary??) -> String {
        let dayChange = dict??.value(forKey: "percent_change_24h") as! String
        if dayChange != "" {
            return "Day: " + dayChange + "%"
        } else {
            return NO_DATA
        }
    }
    
    fileprivate func parseWeekChange(dict: NSDictionary??) -> String {
        let weekChange = dict??.value(forKey: "percent_change_7d") as! String
        if weekChange != "" {
            return "Week: " + weekChange + "%"
        } else {
            return NO_DATA
        }
    }    
    
}
