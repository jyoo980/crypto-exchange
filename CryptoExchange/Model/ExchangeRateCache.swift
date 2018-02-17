//
//  ExchangeRateCache.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-16.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

class ExchangeRateCache {
    
    private var cache = [String : [String:Double]]()
    
    func invalidateCahche() {
        self.cache.removeAll()
    }
    
    func getEntry(crypto: String, real: String) -> Double {
        return self.cache[crypto]![real]!
    }
    
}
