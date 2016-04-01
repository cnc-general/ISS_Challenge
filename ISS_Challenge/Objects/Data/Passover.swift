//
//  Passover.swift
//  ISS_Challenge
//
//  Created by David Cyman on 3/31/16.
//  Copyright (c) 2016 Cyman. All rights reserved.
//

import Foundation
import CoreLocation

private let name_key : String = "name";
private let location_latitude_key : String = "location_lat";
private let location_longitude_key : String = "location_lng";
private let date_key : String = "date";
private let id_key : String = "id";

protocol PassoverDelegate {
    func passoverUpdatedDate();
}

class Passover : NSObject {

    //MARK: Properties
    
    var name : String? {
        get{
            return dataDictionary[name_key] as? String;
        }
        set {
            dataDictionary[name_key] = newValue;
        }
    }

    var location : CLLocation? {
        get{
            let latitude = dataDictionary[location_latitude_key] as? Double;
            let longitude = dataDictionary[location_longitude_key] as? Double;

            if(latitude != nil && longitude != nil) {
                return CLLocation(latitude: latitude!, longitude: longitude!);
            }
            else {
                return CLLocation(latitude: 0, longitude: 0);
            }
        }

        set {
            if let newValue = newValue {
                let latitude = newValue.coordinate.latitude;
                let longitude = newValue.coordinate.longitude;

                dataDictionary[location_latitude_key] = latitude;
                dataDictionary[location_longitude_key] = longitude;
            }
        }
    }

    var date : NSDate? {
        get {
            let timeStamp = dataDictionary[date_key] as? Double;

            if let timeStamp = timeStamp{
                return NSDate(timeIntervalSinceReferenceDate: timeStamp);
            }
            else{
                return nil;
            }
        }

        set {
            if let newValue = newValue {
                dataDictionary[date_key] = (newValue as NSDate!).timeIntervalSinceReferenceDate;
            }
        }
    }
    
    var id : Int? {
        get {
            return dataDictionary[id_key] as? Int;
        }
        set {
            dataDictionary[id_key] = newValue;
        }
    }

    //MARK: Members

    private var dataDictionary = Dictionary<String,AnyObject>();
    
    //MARK: Initializers
    
    override init(){
        super.init();
    }
    
    init(withName name: String, location: CLLocation?){
        super.init();
        
        self.name = name;
        self.location = location;
    }
    
    //MARK: Methods
    
    func getDateAsync(delegate: PassoverDelegate){
        if(self.location != nil){
            WSCaller.GetDate(self.location!, completion:{
                (data: NSData?) -> Void in
                
                if(data != nil){
                    self.parseResponse(data!);
                }
            });
        }
    }
    
    func parseResponse(data: NSData){
        do {
            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue: 0))
            guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                print("Not a Dictionary")
                // put in function
                return
            }
            print("JSONDictionary! \(JSONDictionary)")
        }
        catch let JSONError as NSError {
            print("\(JSONError)")
        }
    }
}
