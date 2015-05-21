//
//  MapViewController.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 5/19/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit
import MapKit

var destinationAddressString: String?

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationmgr = CLLocationManager()
    var intervalString : String?
    var titleString: String?
    var myEvent: EventGroup?
    var currMark: MKPlacemark?
    var destMark: MKPlacemark?
    @IBOutlet weak var etaItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationmgr.delegate = self
        locationmgr.desiredAccuracy = kCLLocationAccuracyBest
        locationmgr.requestWhenInUseAuthorization()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        destinationAddressString = myEvent?.destination
        if destinationAddressString == nil {
            destinationAddressString = kDefaultMeetMeDestination
        }
        self.titleString = destinationAddressString!
        self.title = self.titleString
    }
    
    func initWithEvent(event: EventGroup) {
        myEvent = event
        destinationAddressString = myEvent?.destination
        if destinationAddressString == nil {
            destinationAddressString = kDefaultMeetMeDestination
        }
        self.titleString = destinationAddressString!
        self.title = self.titleString
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.NotDetermined {
            locationmgr.requestWhenInUseAuthorization()
        }
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
             mapView.showsUserLocation = true
            locationmgr.startUpdatingLocation()
            
            let geoCoder = CLGeocoder()
            if (destinationAddressString == nil) {
                destinationAddressString = kDefaultMeetMeDestination
            }
            geoCoder.geocodeAddressString(destinationAddressString, completionHandler: {
                (placemarks:[AnyObject]!, error:NSError!) -> Void in
                
                let topResult : CLPlacemark = (placemarks as? NSArray)!.objectAtIndex(0) as! CLPlacemark
                let placemark : MKPlacemark = MKPlacemark(placemark: topResult)

                self.mapView.addAnnotation(placemark);
                self.centerMapOnLocation(placemark.location);
                
                //Send location fix every 15 sec
                self.sendLocationtimer()
            })
        }
    }
    
    @IBAction func onMessagesTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    //TODO: Optimize the location calls.
    /*func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        switch (manager.desiredAccuracy) {
        case kCLLocationAccuracyThreeKilometers :
                locationmgr.desiredAccuracy = kCLLocationAccuracyKilometer
        default:
            locationmgr.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        //locationmgr.stopUpdatingLocation()
        //locationmgr.startMonitoringSignificantLocationChanges()
        
    }*/
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {

        let geoCoder = CLGeocoder()
        if (destinationAddressString == nil) {
            destinationAddressString = kDefaultMeetMeDestination
        }
        
        geoCoder.geocodeAddressString(destinationAddressString, completionHandler: { (placemarks:[AnyObject]!, error:NSError!) -> Void in
            let topResult : CLPlacemark = (placemarks as? NSArray)!.objectAtIndex(0) as! CLPlacemark
            let placemark : MKPlacemark = MKPlacemark(placemark: topResult)
            
            let currentmark : MKPlacemark = MKPlacemark(coordinate: newLocation.coordinate, addressDictionary: nil)
            
            self.getETA(currentmark, toPlacemark: placemark)
            
            var address = placemark.addressDictionary
            
            self.destMark = placemark
            self.currMark = currentmark
            
            
            //Display the current user's ETA on the title bar.
            if let newETA = self.intervalString {
                self.etaItem.title = newETA
            }
            if let newTitle = address["Name"] as? String {
                self.title = newTitle
                if let newCity = address["City"] as? String {
                    self.myEvent?.destination = newTitle + ", " + newCity
                }
            }
        })
    }
    
    @IBAction func onETAPinTap(sender: AnyObject) {
        if let toLoc = self.destMark?.location {
            self.centerMapOnLocation(toLoc)
        }
    }
    
    @IBAction func onETATapped(sender: AnyObject) {
        if let toLoc = self.currMark?.location {
            self.centerMapOnLocation(toLoc)
        }
    }
    
    func getETA(fromPlacemark:MKPlacemark, toPlacemark:MKPlacemark) {

        //Create request objet
        var request : MKDirectionsRequest = MKDirectionsRequest()
        request.setSource(MKMapItem(placemark:fromPlacemark) )
        request.setDestination(MKMapItem(placemark: toPlacemark))
        request.transportType = MKDirectionsTransportType.Automobile
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculateETAWithCompletionHandler({ (response: MKETAResponse!, error:NSError!) -> Void in
            if (nil == error)
            {
                let interval = (response as MKETAResponse).expectedTravelTime
                let intervalhr = interval/3600
                let intervalmin = (interval%3600)/60
                let intervalsec = (interval%3600)%60
                self.intervalString = String(format: "%.0f:%2.0f:%.0f",intervalhr, intervalmin, intervalsec)
                self.intervalString = NSDate(timeIntervalSinceNow: interval * -1).dateTimeAgo().stringByReplacingOccurrencesOfString("ago", withString: "from now")
                
            }
        })
    }
    
    func sendLocationUpdate() {
        var message = Message()
        message.location = self.intervalString //fromPlacemark.location.description
        message.groupID = myEvent?.groupID
        message.user = User.currentUser
        message.destination = myEvent?.destination
        ParseClient().sharedInstance.sendMessage(message)
    }
    
    func sendLocationtimer() {
        NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "sendLocationUpdate", userInfo: nil, repeats: true)
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chatSegue" {
            var destVC = segue.destinationViewController as! ChatViewController
            destVC.myEvent = self.myEvent
        }
    }

}
