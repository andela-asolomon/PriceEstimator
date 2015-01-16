//
//  EstimatorAPI.swift
//  PriceEstimator
//
//  Created by Ayoola Solomon on 1/16/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import Foundation

class EstimatorAPI {
    
    func query(address: String?, zipCode: Int?){
        
        if address == nil {
            println("nil")
            return
        }
        
        let encodedTerm = (address! as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let urlPath = "https://pure-reef-1653.herokuapp.com/estimate?address1=\(encodedTerm)&address2=&zip=\(zipCode!)"
        let url = NSURL(string: urlPath)
        let request = NSURLRequest(URL: url!)
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if error != nil {
                println("FourSquare Error: \(error)")
                return
            }
            
            let results: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            if results == nil {
                println("No data \(error)")
                return
            }
            
            let currency: NSString = results["currency"] as String
            let offer: Int = results["offer"] as Int
            
            println("The Estimate of your house is \(offer) \(currency)")
        }

    }
}
