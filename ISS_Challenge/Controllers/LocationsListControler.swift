//
//  ViewController.swift
//  ISS_Challenge
//
//  Created by David Cyman on 3/31/16.
//  Copyright © 2016 Cyman. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsListController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, NewLocationDelegate {
    
    let _locationManager = CLLocationManager();
    var _currentLocation : CLLocation? = CLLocation(latitude: 0,longitude: 0);
    var _locationType: NewLocationType = NewLocationType.Coordinates;

    //MARK: Outlets

    @IBOutlet var _locationsTableView: UITableView!;

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        _locationManager.requestWhenInUseAuthorization();
        _locationManager.delegate = self
        _locationManager.distanceFilter = 1000;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.requestAlwaysAuthorization()
        _locationManager.startUpdatingLocation()

        self.title = "Locations";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        if(segue.identifier == "NewSegue") {
            let newLocationController = segue.destinationViewController as! NewLocationController;

            newLocationController.delegate = self;
            newLocationController.locationType = _locationType;
        }
    }


    //MARK: Table View

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(_currentLocation != nil){
            return 2;
        }
        else {
            return 1;
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(_currentLocation == nil || section == 1) {
            return "Friends";
        }
        else{
            return nil;
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as UITableViewCell?;

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "locationCell");
        }

        if(_currentLocation != nil && indexPath.section == 0) {
            cell!.textLabel!.text = "Current Location";
            //TODO: Passover date;
        }
        else{
            //Friend
        }

        return cell!;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {

    }
    
    //MARK: Location Manager

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if(locations.count > 0){
            _currentLocation = locations[0];
            let reloadIndex = NSIndexPath(forRow: 0, inSection: 0)

            _locationsTableView.beginUpdates();
            _locationsTableView.reloadRowsAtIndexPaths([reloadIndex], withRowAnimation: UITableViewRowAnimation.Fade);
            _locationsTableView.endUpdates();
        }
    }

    //MARK: New Location Delegate

    func savedLocation(passover: Passover) {

    }

    //MARK: Actions

    @IBAction func addLocation(sender: UIButton) {
        let coordinateAction = UIAlertAction(title: "Coordinates", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in

            self._locationType = NewLocationType.Coordinates;
        })

        let addressAction = UIAlertAction(title: "Address", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in

            self._locationType = NewLocationType.Address;
        })

        let mapAction = UIAlertAction(title: "Map", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in

            self._locationType = NewLocationType.Map;
        })

        let newLocationSheet = UIAlertController(title: "Create Using:", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet);
        newLocationSheet.addAction(coordinateAction);
        newLocationSheet.addAction(addressAction);
        newLocationSheet.addAction(mapAction);

        self.presentViewController(newLocationSheet, animated: true, completion: nil);
    }
}

