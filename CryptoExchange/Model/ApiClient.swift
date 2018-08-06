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
    private let NUM_DATAPOINTS = "60"
    
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
    
    private func exchangeRateRequest(crypto: String, currency: String, callBack: @escaping (_ result:String) ->()) {
        let requestUrl = coinExchangeRateURL(cryto: crypto, currency: currency)
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
        let requestUrl = historicalExchangeRateURL(crypto: crypto, currency: currency)
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
    
    private func coinExchangeRateURL(cryto: String, currency: String) -> URL {
        var url = "https://min-api.cryptocompare.com/data/price?fsym={CRYPTO}&tsyms={CURRENCIES}"
        url = url.replacingOccurrences(of: "{CRYPTO}", with: cryto)
        url = url.replacingOccurrences(of: "{CURRENCIES}", with: currency)
        return URL(string: url)!
    }
    
    private func historicalExchangeRateURL(crypto: String, currency: String) -> URL {
        let currentTime = unixTime()
        var url = "https://min-api.cryptocompare.com/data/histohour?fsym={CRYPTO}&tsym={REAL}&limit={LIMIT}&toTs={TIME}"
        url = url.replacingOccurrences(of: "{CRYPTO}", with: crypto)
        url = url.replacingOccurrences(of: "{REAL}", with: currency)
        url = url.replacingOccurrences(of: "{LIMIT}", with: NUM_DATAPOINTS)
        url = url.replacingOccurrences(of: "{TIME}", with: currentTime)
        return URL(string: url)!
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
