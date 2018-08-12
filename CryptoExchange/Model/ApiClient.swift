//
//  ApiClient.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-08-06.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class ApiClient {
    
    private let ERROR_CODE = "500"
    private let urlBuilder = UrlBuilder()
    
    func getExchangeRateHistory(crypto: String, currency: String, callBack: @escaping (_ result:NSArray) -> ()) {
        historicalRateRequest(crypto: crypto, currency: currency) { result -> () in
            callBack(result)
        }
    }
    
    func getCryptoExchangeRate(crypto: String, currency: String, callBack: @escaping (_ result:String) -> ()) {
        exchangeRateRequest(crypto: crypto, currency: currency) { result -> () in
            callBack(result)
        }
    }
    
    func getPopViewInfo(crypto: String, currency: String, callBack: @escaping (_ result:[String:String]) -> ()) {
        popViewRequest(crypto: crypto, currency: currency) { result -> () in
            callBack(result)
        }
    }
    
    func getCachedRates(crypto: String, currencies: String, callBack: @escaping (_ result:NSDictionary) -> ()) {
        cachedRateRequest(crypto: crypto, currencies: currencies) { result -> () in
            callBack(result)
        }
    }
    
    private func exchangeRateRequest(crypto: String, currency: String, callBack: @escaping (_ result:String) ->()) {
        let requestUrl = urlBuilder.coinExchangeRateURL(cryto: crypto, currency: currency)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: requestUrl) { (data, _, _) in
            
            if let data = data {
                let responseDict = dataToDict(data: data)
                if responseDict??["error"] == nil {
                    callBack(self.parseConversionRate(responseDict: responseDict, currency: crypto, country: currency))
                } else {
                    callBack(self.ERROR_CODE)
                }
            }
        }
        dataTask.resume()
    }
    
    private func historicalRateRequest(crypto: String, currency: String, callBack:  @escaping (_ result:NSArray) -> ()) {
        let requestUrl = urlBuilder.historicalExchangeRateURL(crypto: crypto, currency: currency)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: requestUrl) { (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    let responseDict = dataToDict(data: data)
                    callBack(responseDict??["Data"] as! NSArray)
                }
            }
        }
        dataTask.resume()
    }
    
    private func popViewRequest(crypto: String, currency: String, callBack: @escaping (_ result:[String:String]) ->()) {
        let requestUrl = urlBuilder.infoViewURL(crypto: crypto, currency: currency)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: requestUrl) { (data, _, _) in
            let responseDict = dataToJSONArray(data: data)
            if responseDict != nil {
                callBack(parseResponse(responseDict: responseDict))
            } else {
                callBack([:])
            }
        }
        dataTask.resume()
    }
    
    private func cachedRateRequest(crypto: String, currencies: String, callBack: @escaping (_ result:NSDictionary) -> ()) {
        let requestUrl = urlBuilder.coinExchangeRateURL(cryto: crypto, currency: currencies)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: requestUrl) { (data, _, _) in
            if let data = data {
                let responseDict = dataToDict(data: data)
                if responseDict??["error"] == nil {
                    callBack(responseDict!!)
                }
            }
        }
        dataTask.resume()
    }
    
    private func parseConversionRate(responseDict: NSDictionary??, currency: String, country: String) -> String {
        let rateAsDouble = responseDict??.value(forKey: country) as! NSNumber
        let exchangeRate = rateAsDouble.doubleValue
        let rate = round(100 * exchangeRate) / 100
        return formatConversionRate(cryptoCurrency: currency, rate: rate, countryCode: country)
    }
    
    private func formatConversionRate(cryptoCurrency: String, rate: Double, countryCode: String) -> String {
        return "1 " + "\(cryptoCurrency)" + " = " + "\(rate)" + " \(countryCode)"
    }
}
