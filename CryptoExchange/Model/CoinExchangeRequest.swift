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
    
    private let request = "https://min-api.cryptocompare.com/data/price?fsym={CRYPTO}&tsyms={CURRENCIES}"
    let API_ERROR = "API Error"
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
    
    func getConversionRate(crypto: String, country: String, completionHandler: @escaping (_ result:String) ->()) {
        let session = URLSession.shared
        let requestURL = generateRequestURL(crypto: crypto, country: country)
        
        let dataTask = session.dataTask(with: requestURL!) { (data, response, error) in
            
            if let data = data {
                let responseDict = dataToDict(data: data)
                if responseDict??["error"] != nil {
                    completionHandler(self.API_ERROR)
                } else {
                    completionHandler(self.parseConversionRate(responseDict: responseDict,currency: crypto, country: country))
                }
            }
        }
        dataTask.resume()
        
    }
    
    fileprivate func generateRequestURL(crypto: String, country: String) -> URL? {
        var requestURL = self.request.replacingOccurrences(of: "{CRYPTO}", with: crypto)
        requestURL = requestURL.replacingOccurrences(of: "{CURRENCIES}", with: country)
        return URL(string: requestURL)
    }
    
    fileprivate func parseConversionRate(responseDict: NSDictionary??, currency: String, country: String) -> String {
        let rateAsDouble = responseDict??.value(forKey: country) as! NSNumber
        let exchangeRate = rateAsDouble.doubleValue
        let rate = round(100 * exchangeRate) / 100
        return conversionString(cryptoCurrency: currency, rate: rate, countryCode: country)
    }
    
    fileprivate func conversionString(cryptoCurrency: String, rate: Double, countryCode: String) -> String {
        return "1 " + "\(cryptoCurrency)" + " = " + "\(rate)" + " \(countryCode)"
    }
    
}
