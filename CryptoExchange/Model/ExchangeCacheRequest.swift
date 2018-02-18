//
//  ExchangeCacheRequest.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-17.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class ExchangeCacheRequest {
    
    private var request = "https://rest.coinapi.io/v1/exchangerate/{CRYPTO}?apikey={APIKEY}"
    private let cacheRequestError = "CACHE ERROR"
    
    func populateCache() {
        let cryptoCurrencies = ViewController.pickerValues[0]
        for crypto in cryptoCurrencies {
            getCacheData(crypto: crypto)
        }
    }
    
    fileprivate func getCacheData(crypto: String) {
        let session = URLSession.shared
        let requestURL = generateCacheURL(crypto: crypto)
        
        let dataTask = session.dataTask(with: requestURL!) { (data, response, error) in
            
            if let data = data {
                let responseDict = dataToDict(data: data)
                if responseDict??["error"] == nil {
                    self.setCache(currency: crypto, responseDict: responseDict)
                }
            }
        }
        dataTask.resume()
    }
    
    fileprivate func generateCacheURL(crypto: String) -> URL? {
        let apiKey = getAPIKey(key: "coinAPIKey")
        var requestURL = self.request.replacingOccurrences(of: "{APIKEY}", with: apiKey)
        requestURL = requestURL.replacingOccurrences(of: "{CRYPTO}", with: crypto)
        return URL(string: requestURL)
    }
    
    fileprivate func setCache(currency: String, responseDict: NSDictionary??) {
        let rateArray = responseDict??.value(forKey: "rates") as! NSArray
        for realCurrency in ViewController.pickerValues[1] {
            for rateEntry in rateArray {
                let rateDict = rateEntry as! NSDictionary
                if realCurrency == rateDict["asset_id_quote"] as! String {
                    let exchangeRate = sanitizeRate(rate: rateDict["rate"] as! NSDecimalNumber)
                    ExchangeRateCache.shared.set(crypto: currency, real: realCurrency, conversionRate: exchangeRate)
                }
            }
        }
    }
    
    fileprivate func sanitizeRate(rate: NSDecimalNumber) -> Double {
        let rateAsDouble = rate.doubleValue
        return round(100 * rateAsDouble) / 100
    }
    
}
