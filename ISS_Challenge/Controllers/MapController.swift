//
//  MapController.swift
//  ISS_Challenge
//
//  Created by David Cyman on 4/1/16.
//  Copyright © 2016 Cyman. All rights reserved.
//

import Foundation
import MapKit

class MapController : UIViewController, MKMapViewDelegate {
    
    var locations = [Passover]?();
    
    @IBOutlet var mapView: MKMapView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        mapView.delegate = self;
        
        if(locations != nil){
            for passover : Passover in locations! {
                let point = MKPointAnnotation();
                
                if(passover.name != nil){
                    point.title = passover.name!;
                }
                
                if(passover.location != nil){
                    point.coordinate = passover.location!.coordinate;
                    
                    mapView.addAnnotation(point);
                }
            }
        }
        
        getISSLocation();
    }
    
    func getISSLocation() {
        WSCaller.GetISS({
            (data: NSData?) -> Void in
            
            if(data != nil){
                self.parseResponse(data!)
            }
        })
    }
    
    
    func parseResponse(data: NSData){
        do {
            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue: 0))
            guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                print("Not a Dictionary")
                // put in function
                return
            }
            
            let response = JSONDictionary.objectForKey("iss_position") as? NSDictionary;
            if(response != nil){
                let latitudeString = response!.objectForKey("latitude")
                let latitude = latitudeString as? Double;
                
                let longitudeString = response!.objectForKey("longitude")
                let longitude = longitudeString as? Double;
                
                if(latitude != nil && longitude != nil){
                    let point = MKPointAnnotation();
                    point.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!);
                    point.title = "ISS";
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mapView.addAnnotation(point);
                    });
                }
            }
            
        }
        catch let JSONError as NSError {
            print("\(JSONError)")
        }
    }
    
    //MARK: Map View
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView();
        
        let point = annotation as! MKPointAnnotation;
        
        if(point.title == "ISS"){
            pin.pinTintColor = UIColor.purpleColor();
        }
        else{
            pin.pinTintColor = UIColor.greenColor();
        }
        
        return pin;
    }
}