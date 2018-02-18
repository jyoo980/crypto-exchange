//
//  ExchangeCacheRequest.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-17.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class ExchangeCacheRequest {
    
    private var request = "https://min-api.cryptocompare.com/data/price?fsym={CRYPTO}&tsyms={CURRENCIES}"
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
                    self.setCache(crypto: crypto, rateDict: responseDict)
                }
            }
        }
        dataTask.resume()
    }
    
    fileprivate func generateCacheURL(crypto: String) -> URL? {
        let currencyList = self.currencyList()
        var requestURL = self.request.replacingOccurrences(of: "{CRYPTO}", with: crypto)
        requestURL = requestURL.replacingOccurrences(of: "{CURRENCIES}", with: currencyList)
        return URL(string: requestURL)
    }
    
    fileprivate func currencyList() -> String {
        return ViewController.pickerValues[1].joined(separator: ",")
    }
    
    fileprivate func setCache(crypto: String, rateDict: NSDictionary??) {
        let currencies = ViewController.pickerValues[1]
        for currency in currencies {
            let exchRate = sanitizeRate(rate: rateDict??.value(forKey: currency) as! NSNumber)
            ExchangeRateCache.shared.set(crypto: crypto, real: currency, conversionRate: exchRate)
        }
    }
    
    fileprivate func sanitizeRate(rate: NSNumber) -> Double {
        return rate.doubleValue
    }
    
}
