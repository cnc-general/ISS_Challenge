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

    var selectedLocation : CLLocation = CLLocation(latitude: 0, longitude: 0);

    private var _locationType: NewLocationType = NewLocationType.Coordinates;
    var locationType: NewLocationType {
        get {
            return _locationType;
        }
        set {
            _locationType = newValue;

            coordinatesLabel.hidden = (_locationType != NewLocationType.Coordinates);
            latitudeField.hidden = (_locationType != NewLocationType.Coordinates);
            longitudeField.hidden = (_locationType != NewLocationType.Coordinates);

            addressLabel.hidden = (_locationType != NewLocationType.Address);
            addressField.hidden = (_locationType != NewLocationType.Address);

            mapLabel.hidden = (_locationType != NewLocationType.Map);
            mapView.hidden = (_locationType != NewLocationType.Map);
        }
    }

    //MARK: Outlets

    @IBOutlet var nameLavel : UILabel!;
    @IBOutlet var nameField : UIField!;
    
    @IBOutlet var coordinatesLabel: UILabel!;
    @IBOutlet var latitudeField: UITextField!;
    @IBOutlet var longitudeField: UITextField!;

    @IBOutlet var addressLabel: UILabel!;
    @IBOutlet var addressField: UITextField!;

    @IBOutlet var mapLabel: UILabel!;
    @IBOutlet var mapView: MKMapView!;

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(_locationType == NewLocationType.Map){
            let mapTapRecog = UITapGestureRecognizer(target: self, action: #selector(self.handleMapTap(_:)));
            mapView.addGestureRecognizer(mapTapRecog);
        }
        
        self.title = "Locations";
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Map View


    //MARK: Actions
    
    @IBAction func save(sender: UIButton) {

    }
    
    func handleMapTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.locationInView(mapView);
        let tapCoordinates = mapView.convertPoint(tapLocation, toCoordinateFromView: mapView);
        
        if let delegate = delegate {
            let location = CLLocation.init(latitude: tapCoordinates.latitude, longitude: tapCoordinates.longitude);
        }
    }
}