//
//  WSCaller.swift
//  ISS_Challenge
//
//  Created by David Cyman on 4/1/16.
//  Copyright © 2016 Cyman. All rights reserved.
//

import Foundation
import CoreLocation

class WSCaller: NSObject {
    
    class func GetDate(location: CLLocation, completion: (NSData?) -> Void) {
        if let request = restGetRequest(location){
            send(request, completion:completion);
        }
        else{
            completion(nil);
        }
    }
    
    class func send(request: NSURLRequest, completion: (NSData?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            completion(data);
        }
        
        task.resume();
    }
    
    
    class func restGetRequest(location: CLLocation) -> NSURLRequest? {
        let restURL = restGetURL(location);
        
        let request = NSMutableURLRequest();
        request.URL = restURL;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        request.addValue("application/json", forHTTPHeaderField: "Accept");
        
        request.HTTPMethod = "GET";
        
        return request;
    }
    
    
    private class func restGetURL(location: CLLocation) -> NSURL {
        var urlString = "http://api.open-notify.org/iss-pass.json?"
        
        urlString += "lat=" + String(location.coordinate.latitude);
        urlString += "&";
        urlString += "lon=" + String(location.coordinate.longitude);
        
        return NSURL(string: urlString)!;
    }
}
