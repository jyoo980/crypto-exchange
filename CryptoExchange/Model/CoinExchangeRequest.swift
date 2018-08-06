//
//  CoinExchangeRequest.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-15.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation
import Charts

class CoinExchangeRequest {
    
    let cache = ExchangeRateCache.shared
    let CACHE_MISS = "-1"
    
    func fetchFromCache(crypto: String, country: String) -> String {
        let fetchedVal = cache.fetch(crypto: crypto, real: country)
        if (fetchedVal != cache.CACHE_MISS) {
            return conversionString(cryptoCurrency: crypto, rate: fetchedVal, countryCode: country)
        } else {
            return CACHE_MISS
        }
    }
    
    private func conversionString(cryptoCurrency: String, rate: Double, countryCode: String) -> String {
        return "1 " + "\(cryptoCurrency)" + " = " + "\(rate)" + " \(countryCode)"
    }
    
}
