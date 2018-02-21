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
    private var cache : [String:LineChartDataSet]
    
    private init() {
        self.cache = [String:LineChartDataSet]()
    }
    
    func invalidate() {
        self.cache.removeAll()
    }
    
     func dataSetPresent(crypto: String) -> Bool {
        return self.cache[crypto] != nil
    }
    
    func fetch(crypto: String) -> LineChartDataSet {
        return self.cache[crypto]!
    }
    
    func set(crypto: String, data: LineChartDataSet) {
        if (self.cache[crypto] == nil) {
            self.cache[crypto] = data
        }
    }
    
}
