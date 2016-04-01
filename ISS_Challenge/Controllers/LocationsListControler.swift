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
    var _currentLocation : CLLocation? = CLLocation(latitude: 0,longitude: 0);
    var _locationType: NewLocationType = NewLocationType.Coordinates;
    
    var locations = [Passover]();
    
    let formatter : NSDateFormatter = NSDateFormatter();

    //MARK: Outlets

    @IBOutlet var _locationsTableView: UITableView!;

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if(_currentLocation != nil && section == 0){
            return 1;
        }
        else {
            return locations.count;
        }
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
            let passover = locations[indexPath.row];
            cell!.textLabel!.text = passover.name;
            
            if(passover.date != nil){
                cell!.detailTextLabel!.text = formatter.stringFromDate(passover.date!);
            }
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
        self.navigationController?.popViewControllerAnimated(true);
        
        locations.append(passover)
        
        let indexSet = NSMutableIndexSet();
        
        if(_currentLocation != nil){
            indexSet.addIndex(1);
        }
        else {
            indexSet.addIndex(0);
        }
        
        _locationsTableView.beginUpdates();
        _locationsTableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic);
        _locationsTableView.endUpdates();
    }
    
    //MARK: Passover Delegate
    
    func passoverUpdatedDate() {
        
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
}

