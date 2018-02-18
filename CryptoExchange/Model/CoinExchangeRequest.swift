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
    
    private var exchRequest = "https://rest.coinapi.io/v1/exchangerate/{CRPTO}/{REAL}?apikey={APIKEY}"
    let callExceededText = "API Calls Exceeded"
    let CRYPTO_KEY = "asset_id_base"
    let REAL_KEY = "asset_id_quote"
    let RATE_KEY = "rate"
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
                    completionHandler(self.callExceededText)
                } else {
                    completionHandler(self.parseConversionRate(responseDict: responseDict))
                }
            }
        }
        dataTask.resume()
        
    }
    
    fileprivate func generateRequestURL(crypto: String, country: String) -> URL? {
        let apiKey = getAPIKey(key: "coinAPIKey")
        var requestURL = self.exchRequest.replacingOccurrences(of: "{CRPTO}", with: crypto)
        requestURL = requestURL.replacingOccurrences(of: "{REAL}", with: country)
        requestURL = requestURL.replacingOccurrences(of: "{APIKEY}", with: apiKey)
        return URL(string: requestURL)
    }
    
    fileprivate func parseConversionRate(responseDict: NSDictionary??) -> String {
        let cryptoCost = responseDict??.value(forKey: CRYPTO_KEY) as! String
        let realCost = responseDict??.value(forKey: REAL_KEY) as! String
        let rateAsDouble = responseDict??.value(forKey: RATE_KEY) as! NSDecimalNumber
        let exchangeRate = rateAsDouble.doubleValue
        let rate = round(100 * exchangeRate) / 100
        return conversionString(cryptoCurrency: cryptoCost, rate: rate, countryCode: realCost)
    }
    
    fileprivate func conversionString(cryptoCurrency: String, rate: Double, countryCode: String) -> String {
        return "1 " + "\(cryptoCurrency)" + " = " + "\(rate)" + " \(countryCode)"
    }
    
}
