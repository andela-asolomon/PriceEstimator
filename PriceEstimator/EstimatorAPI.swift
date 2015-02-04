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
    
    var results: AnyObject = "Try Again"
    
    func query(address: String, zipCode: Int) {
        
        let encodedTerm = (address as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let urlPath = "https://pure-reef-1653.herokuapp.com/estimate?address1=\(encodedTerm)&address2=&zip=\(zipCode)"
        let queue: NSOperationQueue = NSOperationQueue()
        
        let estimateUrl = NSURL(string: urlPath)
        let request = NSURLRequest(URL: estimateUrl!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            
            if let results: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: error) as AnyObject! {
                if results.count > 0 {
                    self.delegate?.JSONAPIResults(results)
                } else {
                    println(error)
                }
            } else {
                self.delegate?.JSONAPIResults(self.results)
            }
        }
    }
}
