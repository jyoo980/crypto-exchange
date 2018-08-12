//
//  UrlBuilder.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-08-11.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class UrlBuilder {
    
    private let cryptoCompareBaseUrl = "https://min-api.cryptocompare.com/data/price?fsym={CRYPTO}&tsyms={CURRENCIES}"
    private let historicRateBaseUrl = "https://min-api.cryptocompare.com/data/histohour?fsym={CRYPTO}&tsym={REAL}&limit={LIMIT}&toTs={TIME}"
    private let coinMarketCapBaseUrl = "https://api.coinmarketcap.com/v1/ticker/{CRYPTO}/?convert={REAL}"
    private let cryptoDict = ["BCH":"bitcoin-cash", "BTC":"bitcoin", "BTG":"bitcoin-gold", "DOGE":"dogecoin", "ETH":"ethereum", "LTC":"litecoin", "XRP":"ripple"]
    
    public func infoViewURL(crypto: String, currency: String) -> URL {
        var url = coinMarketCapBaseUrl.replacingOccurrences(of: "{CRYPTO}", with: cryptoDict[crypto]!)
        url = url.replacingOccurrences(of: "{REAL}", with: currency)
        return URL(string: url)!
    }
    
    public func coinExchangeRateURL(cryto: String, currency: String) -> URL {
        var url = cryptoCompareBaseUrl
        url = url.replacingOccurrences(of: "{CRYPTO}", with: cryto)
        url = url.replacingOccurrences(of: "{CURRENCIES}", with: currency)
        return URL(string: url)!
    }
    
    public func historicalExchangeRateURL(crypto: String, currency: String) -> URL {
        let currentTime = unixTime()
        var url = historicRateBaseUrl
        url = url.replacingOccurrences(of: "{CRYPTO}", with: crypto)
        url = url.replacingOccurrences(of: "{REAL}", with: currency)
        url = url.replacingOccurrences(of: "{LIMIT}", with: "60")
        url = url.replacingOccurrences(of: "{TIME}", with: currentTime)
        return URL(string: url)!
    }

}
