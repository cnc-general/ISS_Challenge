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
        let url = restGetPassoverURL(location);
        
        if let request = restGetRequest(url){
            send(request, completion:completion);
        }
        else{
            completion(nil);
        }
    }
    
    class func GetISS(completion: (NSData?) -> Void) {
        let url = restGetISSURL();
        
        if let request = restGetRequest(url){
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
    
    
    class func restGetRequest(url: NSURL) -> NSURLRequest? {
        
        let request = NSMutableURLRequest();
        request.URL = url;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        request.addValue("application/json", forHTTPHeaderField: "Accept");
        
        request.HTTPMethod = "GET";
        
        return request;
    }
    
    
    private class func restGetPassoverURL(location: CLLocation) -> NSURL {
        var urlString = "http://api.open-notify.org/iss-pass.json?"
        
        urlString += "lat=" + String(location.coordinate.latitude);
        urlString += "&";
        urlString += "lon=" + String(location.coordinate.longitude);
        
        return NSURL(string: urlString)!;
    }
    
    private class func restGetISSURL() -> NSURL {
        let urlString = "http://api.open-notify.org/iss-now.json"
        return NSURL(string: urlString)!;
    }
}
