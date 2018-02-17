//
//  Utility.swift
//  CryptoExchange
//
//  Created by James Yoo on 2018-02-13.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

func getAPIKey(key: String) -> String {
    let filePath = Bundle.main.path(forResource: "keys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    let value = plist?.object(forKey: key) as! String
    return value
}

func dataToDict(data: Data?) -> NSDictionary?? {
    return try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
}

