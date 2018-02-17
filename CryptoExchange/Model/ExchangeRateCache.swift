//
//  ExchangeRateCache.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-16.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class ExchangeRateCache {
    
    static let shared = ExchangeRateCache()
    
    private var cache : [String:[String:Double]]
    
    private init() {
        self.cache = [String:[String:Double]]()
    }
    
    func invalidate() {
        self.cache.removeAll()
    }
    
    func fetch(crypto: String, real: String) -> Double {
        return self.cache[crypto]![real]!
    }
    
    func set(crypto: String, real: String, conversionRate: Double) {
        self.cache[crypto]![real] = conversionRate
    }
    
}
