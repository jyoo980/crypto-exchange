//
//  ExchangeRateCache.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-17.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class ExchangeRateCache {
    
    static let shared = ExchangeRateCache()
    
    var cache : [String:[[String:Double]]]
    var CACHE_MISS = -1.0
    
    private init() {
        self.cache = [String:[[String:Double]]]()
    }
    
    func invalidate() {
        self.cache.removeAll()
    }
    
    func fetch(crypto: String, real: String) -> Double {
        let rateArray = self.cache[crypto]
        if rateArray != nil {
            return nestedFetch(rateArray, real)
        } else {
            return CACHE_MISS
        }
    }
    
    fileprivate func nestedFetch(_ rateArray: [[String : Double]]?, _ real: String) -> Double {
        for rate in rateArray! {
            let hit = rate[real]
            if hit != nil {
                return hit!
            }
        }
        return CACHE_MISS
    }
        
    func set(crypto: String, real: String, conversionRate: Double) {
        let duple = [real : conversionRate]
        if (self.cache[crypto] != nil) {
            self.cache[crypto]?.append(duple)
        } else {            
            self.cache[crypto] = []
            self.cache[crypto]?.append(duple)
        }
    }
    
}
