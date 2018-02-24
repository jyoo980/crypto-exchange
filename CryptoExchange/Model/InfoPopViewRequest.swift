//
//  InfoPopViewRequest.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-23.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class InfoPopViewRequest {
    
    private let request = "https://api.cryptonator.com/api/ticker/{CRYPTO}-{REAL}"
    private let REQUEST_ERROR = ["REQUEST_ERROR":"ERROR"]
    private let NO_DATA = "No data"
    
    func getReponseData(crypto: String, country: String, completionHandler: @escaping (_ result:[String:String]) ->()) {
        let session = URLSession.shared
        let requestURL = generateRequestURL(cryptoCurrency: crypto, realCurrency: country)
        
        let dataTask = session.dataTask(with: requestURL!) { (data, response, error) in
            
            if let data = data {
                let responseDict = dataToDict(data: data)
                if responseDict??["error"] != nil {
                    completionHandler(self.parseResponse(responseDict: responseDict))
                } else {
                    completionHandler(self.REQUEST_ERROR)
                }
            }
        }
        dataTask.resume()
    }
    
    fileprivate func generateRequestURL(cryptoCurrency: String, realCurrency: String) -> URL? {
        var requestURL = self.request.replacingOccurrences(of: "{CRYPTO}", with: cryptoCurrency)
        requestURL = requestURL.replacingOccurrences(of: "{REAL}", with: realCurrency)
        return URL(string: requestURL)
    }
    
    fileprivate func parseResponse(responseDict: NSDictionary??) -> [String:String] {
        var parsedData = [String:String]()
        let tickerDict = responseDict??.value(forKey: "ticker") as! NSDictionary
        let hourChange = getHourChange(dict: tickerDict)
        let volume = getVolume(dict: tickerDict)
        parsedData["hourChange"] = hourChange
        parsedData["volume"] = volume
        return parsedData
    }
    
    fileprivate func getHourChange(dict: NSDictionary??) -> String {
        let hourChange = dict??.value(forKey: "change") as! String
        if hourChange != "" {
            return hourChange
        } else {
            return NO_DATA
        }
    }
    
    fileprivate func getVolume(dict: NSDictionary??) -> String {
        let volume = dict??.value(forKey: "volume") as! String
        if volume != "" {
            return volume
        } else {
            return NO_DATA
        }
    }    
    
}
