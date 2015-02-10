//
//  EstimatorAPI.swift
//  PriceEstimator
//
//  Created by Ayoola Solomon on 1/16/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import Foundation
import UIKit

protocol EstimatorAPIProtocol {
    func JSONAPIResults(results: AnyObject)
}

class EstimatorAPI: UIViewController {
    
    var delegate: EstimatorAPIProtocol?
    
    var searchResults : Double = 0.0
    
    var results: AnyObject = "Try Again"
    
    func urlWithSearchText(address: String, zipCode: Int) -> NSURL {
        let escapedSearchText = address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let urlPath = "https://pure-reef-1653.herokuapp.com/estimate?address1=\(escapedSearchText)&address2=&zip=\(zipCode)"
        let url = NSURL(string: urlPath)
        return url!
    }
    
    func parseJSON(data: NSData) -> [String: AnyObject]? {
        var error: NSError?
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error) as? [String: AnyObject] {
            println("result: \(json)")
            return json
        } else if let error = error {
            println("JSON Error: \(error)")
        } else {
            println("Unknown JSON Error")
        }
        return nil
    }
    
    func parseOffer(dictionary: [String: AnyObject]) -> Double {
        let searchResult = Estimate()
        
        searchResult.offer = dictionary["offer"] as Double
        
        return searchResult.offer
    }
    
    func query(address: String, zipCode: Int) {
        
        searchResults = Double()
        
        let encodedTerm = (address as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue) {
            
            let urlPath = "https://pure-reef-1653.herokuapp.com/estimate?address1=\(encodedTerm)&address2=&zip=\(zipCode)"
            let estimateUrl = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            
            let dataTask = session.dataTaskWithURL(estimateUrl!, completionHandler: { (data, response, error) -> Void in
                if let error = error {
                    self.delegate?.JSONAPIResults(self.results)
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == StatusCode.Ok {
                        if let dictionary = self.parseJSON(data) {
                            self.searchResults = self.parseOffer(dictionary)
                            self.delegate?.JSONAPIResults(self.searchResults)
                            return
                        }
                    } else {
                        println("response: \(response)")
                        self.delegate?.JSONAPIResults(httpResponse.statusCode)
                    }
                }
            })
            
            dataTask.resume()
        }
    }
}
