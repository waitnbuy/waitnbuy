
//
//  Internet_Connection.swift
//  WaitnBuy
//
//  Created by Leonid Tuzenko on 30.09.15.
//  Copyright © 2015 Wait & Buy. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        do {
            _ = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        } catch let error as NSError{
            print (error.localizedDescription)
            return false;
        }
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
    
}