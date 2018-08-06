//
//  GraphDataCache.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-20.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation
import Charts

class GraphDataCache {
    
    static let shared = GraphDataCache()
    private let GRAPH_DATA_CACHE_MISS = LineChartDataSet()
    private var cache : [String:[[String:LineChartDataSet]]]
    
    private init() {
        self.cache = [String:[[String:LineChartDataSet]]]()
    }
    
    func invalidate() {
        self.cache.removeAll()
    }
    
    func isDataSetPresent(cryptoCurrency: String, realCurrency: String) -> Bool {
        if let cryptoCache = self.cache[cryptoCurrency] {
            for cacheEntry in cryptoCache {
                let realEntry = cacheEntry[realCurrency]
                if realEntry != nil {
                    return true
                }
            }
        }
        return false
    }
    
    func fetch(cryptoCurrency: String, realCurrency: String) -> LineChartDataSet {
        let cryptoArray = self.cache[cryptoCurrency]
        if cryptoArray != nil {
            return nestedFetch(crypoArray: cryptoArray!, realCurrency: realCurrency)
        } else {
            return GRAPH_DATA_CACHE_MISS
        }
    }
    
    fileprivate func nestedFetch(crypoArray: [[String:LineChartDataSet]], realCurrency: String) -> LineChartDataSet {
        for crypto in crypoArray {
            let hit = crypto[realCurrency]
            if hit != nil {
                return hit!
            }
        }
        return GRAPH_DATA_CACHE_MISS
    }
    
    func set(cryptoCurrency: String, realCurrency: String, data: LineChartDataSet) {
        let duple = [realCurrency : data]
        
        if self.cache[cryptoCurrency] != nil {
            self.cache[cryptoCurrency]?.append(duple)
        } else {
            self.cache[cryptoCurrency] = []
            self.cache[cryptoCurrency]?.append(duple)
        }
        
    }
}
