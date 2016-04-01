//
//  ViewController.swift
//  ISS_Challenge
//
//  Created by David Cyman on 3/31/16.
//  Copyright © 2016 Cyman. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsListController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, NewLocationDelegate, PassoverDelegate {
    
    let _locationManager = CLLocationManager();
    var _locationType: NewLocationType = NewLocationType.Coordinates;
    
    var locations = [Passover]();
    
    let formatter : NSDateFormatter = NSDateFormatter();

    //MARK: Outlets

    @IBOutlet var _locationsTableView: UITableView!;

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _locationsTableView.allowsSelection = false;
        
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a";

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
        if(segue.identifier == "MapSegue"){
            let mapController = segue.destinationViewController as! MapController;
            
            mapController.locations = locations;
        }
    }


    //MARK: Table View

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as UITableViewCell?;

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "locationCell");
        }

        let passover = locations[indexPath.row];
        cell!.textLabel!.text = passover.name;
        
        if(passover.date != nil){
            cell!.detailTextLabel!.text = formatter.stringFromDate(passover.date!);
        }

        return cell!;
    }
    
    //MARK: Location Manager

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if(locations.count > 0){
            
            _locationManager.stopUpdatingLocation();
            
            let currentLocation = locations[0];
            
            let currentPassover = Passover(withName: "Current Location", location: currentLocation);
            
            self.locations.append(currentPassover);
            
            _locationsTableView.reloadData();
            
            currentPassover.getDateAsync(self);
        }
    }

    //MARK: New Location Delegate

    func savedLocation(passover: Passover) {
        self.navigationController?.popViewControllerAnimated(true);
        
        locations.append(passover)
        
        _locationsTableView.reloadData();
        
        passover.getDateAsync(self);
    }
    
    //MARK: Passover Delegate
    
    func passoverUpdatedDate(passover: Passover) {
        _locationsTableView.reloadData();
        
        if(passover.name == "Current Location"){
            let notification = UILocalNotification();
            notification.alertTitle = "ISS is passing over your current location!";
            notification.fireDate = passover.date;
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification);
        }
    }

    //MARK: Actions

    @IBAction func addLocation(sender: UIButton) {
        let coordinateAction = UIAlertAction(title: "Coordinates", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in

            self._locationType = NewLocationType.Coordinates;
            
            self.performSegueWithIdentifier("NewSegue", sender: self);
        })

        let addressAction = UIAlertAction(title: "Address", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in

            self._locationType = NewLocationType.Address;
            
            self.performSegueWithIdentifier("NewSegue", sender: self);
        })

        let mapAction = UIAlertAction(title: "Map", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in

            self._locationType = NewLocationType.Map;
            
            self.performSegueWithIdentifier("NewSegue", sender: self);
        })

        let newLocationSheet = UIAlertController(title: "Create Using:", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet);
        newLocationSheet.addAction(coordinateAction);
        newLocationSheet.addAction(addressAction);
        newLocationSheet.addAction(mapAction);

        self.presentViewController(newLocationSheet, animated: true, completion: nil);
    }
    
    @IBAction func showMap(sender: UIButton){
        self.performSegueWithIdentifier("MapSegue", sender: self);
    }
}

