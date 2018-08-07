//
//  ExchangeCacheRequest.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-17.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class ExchangeCacheRequest {
    
    private let apiClient = ApiClient()
    
    func populateCache() {
        let cryptoCurrencies = ViewController.pickerValues[0]
        for crypto in cryptoCurrencies {
            getCacheData(crypto: crypto)
        }
    }
    
    private func getCacheData(crypto: String) {
        let currencyList = self.currencyList()
        apiClient.getCachedRates(crypto: crypto, currencies: currencyList) { result -> () in
            self.setCache(crypto: crypto, rateDict: result)
        }
    }
    
    private func currencyList() -> String {
        return ViewController.pickerValues[1].joined(separator: ",")
    }
    
    private func setCache(crypto: String, rateDict: NSDictionary??) {
        let currencies = ViewController.pickerValues[1]
        for currency in currencies {
            let exchRate = sanitizeRate(rate: rateDict??.value(forKey: currency) as! NSNumber)
            ExchangeRateCache.shared.set(crypto: crypto, real: currency, conversionRate: exchRate)
        }
    }
    
    private func sanitizeRate(rate: NSNumber) -> Double {
        return rate.doubleValue
    }
    
}
