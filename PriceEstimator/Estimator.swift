//
//  Estimator.swift
//  PriceEstimator
//
//  Created by Ayoola Solomon on 1/20/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import Foundation

class Estimator {
    var offer: Int?
    var currency: String?
    
    init(data: AnyObject) {
        
        let offerAPI = getIntFromJSON(data, key: "offer")
        self.offer = offerAPI
        
        let currencyAPI = getStringFromJSON(data, key: "currency")
        self.currency = currencyAPI
    }
    
    func getIntFromJSON(data : AnyObject, key: String) -> Int {
        if let info = data[key] as? Int {
            return info
        }
        
        return 0
    }
    
    func getStringFromJSON(data: AnyObject, key : String) -> String {
        if let info = data[key] as? String {
            return info
        }
        
        return ""
    }
}
