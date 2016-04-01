//
//  NewLocationController.swift
//  ISS_Challenge
//
//  Created by David Cyman on 3/31/16.
//  Copyright © 2016 Cyman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum NewLocationType : Int {
    case Coordinates;
    case Address;
    case Map;
}

protocol NewLocationDelegate {
    func savedLocation(passover: Passover);
}

class NewLocationController : UIViewController, MKMapViewDelegate {
    
    //MARK: Properties
    
    var delegate : NewLocationDelegate?;

    var locationType: NewLocationType = NewLocationType.Coordinates;

    //MARK: Outlets

    @IBOutlet var nameLabel : UILabel!;
    @IBOutlet var nameField : UITextField!;
    
    @IBOutlet var coordinatesLabel: UILabel!;
    @IBOutlet var latitudeField: UITextField!;
    @IBOutlet var longitudeField: UITextField!;

    @IBOutlet var addressLabel: UILabel!;
    @IBOutlet var addressField: UITextField!;

    @IBOutlet var mapLabel: UILabel!;
    @IBOutlet var mapView: MKMapView!;

    private var selectedLocation : CLLocation = CLLocation(latitude: 0, longitude: 0);
    private var tappedLocation : MKPointAnnotation? = nil;


    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Locations";

        coordinatesLabel.hidden = (locationType != NewLocationType.Coordinates);
        latitudeField.hidden = (locationType != NewLocationType.Coordinates);
        longitudeField.hidden = (locationType != NewLocationType.Coordinates);

        addressLabel.hidden = (locationType != NewLocationType.Address);
        addressField.hidden = (locationType != NewLocationType.Address);

        mapLabel.hidden = (locationType != NewLocationType.Map);
        mapView.hidden = (locationType != NewLocationType.Map);

        if(locationType == NewLocationType.Map){
            let mapTapRecog = UITapGestureRecognizer(target: self, action: #selector(self.handleMapTap(_:)));
            mapView.addGestureRecognizer(mapTapRecog);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Map View


    //MARK: Actions
    
    func handleMapTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.locationInView(mapView);
        let tapCoordinates = mapView.convertPoint(tapLocation, toCoordinateFromView: mapView);
        
        let location = CLLocation.init(latitude: tapCoordinates.latitude, longitude: tapCoordinates.longitude);
        
        if(tappedLocation != nil){
            mapView.removeAnnotation(tappedLocation!);
        }
        
        tappedLocation = MKPointAnnotation();
        tappedLocation!.coordinate = location.coordinate;
        mapView.addAnnotation(tappedLocation!);
        
        selectedLocation = location;
    }
    
    @IBAction func save(sender: UIButton) {
        if(nameField.text != nil){
            if(locationType == NewLocationType.Coordinates) {
                saveCoordinates();
            }
            else if(locationType == NewLocationType.Address) {
                saveAddress();
            }
            else if(locationType == NewLocationType.Map) {
                saveMap();
            }
        }
    }
    
    func saveCoordinates(){
        if(latitudeField.text != nil && longitudeField.text != nil){
            let latitude = Double(latitudeField.text!);
            let longitude = Double(longitudeField.text!);
            
            if(latitude != nil && longitude != nil){
                let name = nameField.text!;
                let location = CLLocation(latitude: latitude!, longitude: longitude!);
                
                let passover = Passover(withName: name, location: location)
                
                sendToDelegate(passover);
            }
        }
    }
    
    func saveAddress() {
        if let address = addressField.text {
            CLGeocoder().geocodeAddressString(address, completionHandler: {
                (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                
                if(error == nil && placemarks != nil && placemarks?.count > 0){
                    let placemark = placemarks![0];
                    
                    let name = self.nameField.text!;
                    let passover = Passover(withName: name, location: placemark.location);
                    
                    self.sendToDelegate(passover);
                }
                else{
                    //TODO: No Address Matched
                }
            })
        }
    }
    
    func saveMap(){
        let name = nameField.text!;
        
        let passover = Passover(withName: name, location: selectedLocation);
        
        sendToDelegate(passover);
    }
    
    func sendToDelegate(passover: Passover){
        if let delegate = delegate {
            delegate.savedLocation(passover);
        }
    }
}