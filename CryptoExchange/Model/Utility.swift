//
//  Utility.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-13.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

func dataToDict(data: Data?) -> NSDictionary?? {
    return try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
}

func dataToJSONArray(data: Data?) -> NSArray?? {
    return try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray
}

func unixTime() -> String {
    var unixTime = NSDate().timeIntervalSince1970.description
    if let dotRange = unixTime.range(of: ".") {
        unixTime.removeSubrange(dotRange.lowerBound..<unixTime.endIndex)
    }
    return unixTime
}
