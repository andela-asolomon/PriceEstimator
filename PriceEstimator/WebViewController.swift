//
//  WebViewController.swift
//  FoodPin
//
//  Created by Ayoola Solomon on 1/12/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit


class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor(red: 255.0/255.0, green: 89.0/255.0, blue: 20.0/255.0, alpha: 1)
        self.view.addSubview(activityIndicator)
        // Do any additional setup after loading the view.
        loadAddress()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAddress(){
        let requestUrl = NSURL(string: "http://www.soldtoday.com")
        let request = NSURLRequest(URL: requestUrl!)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(_: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
