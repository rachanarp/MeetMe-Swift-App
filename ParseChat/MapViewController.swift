//
//  MapViewController.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 5/19/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

 
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationmgr = CLLocationManager()
    @IBOutlet weak var destinationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set initial location in Honolulu
        mapView.delegate = self
        locationmgr.delegate = self
        locationmgr.desiredAccuracy = kCLLocationAccuracyBest
        locationmgr.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.NotDetermined {
            locationmgr.requestWhenInUseAuthorization()
        }
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
             mapView.showsUserLocation = true
            locationmgr.startUpdatingLocation()
            
            //Rdio 37.7676116,-122.4109711
            let destinationLocation = CLLocation(latitude: 37.7676116, longitude: -122.4109711)
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString("1550 Bryant Street, San Francisco, CA", completionHandler: { (placemarks:[AnyObject]!, error:NSError!) -> Void in
                let topResult : CLPlacemark = (placemarks as? NSArray)!.objectAtIndex(0) as! CLPlacemark
                let placemark : MKPlacemark = MKPlacemark(placemark: topResult)

                self.mapView.addAnnotation(placemark);
                self.centerMapOnLocation(placemark.location);
                
                var request : MKDirectionsRequest = MKDirectionsRequest()
                //ritual coffee : 37.755185, -122.424366
                request.setSource(MKMapItem.mapItemForCurrentLocation())
                request.setDestination(MKMapItem(placemark: placemark))
                request.transportType = MKDirectionsTransportType.Automobile
                request.requestsAlternateRoutes = false
                let directions = MKDirections(request: request)
                directions.calculateETAWithCompletionHandler({ (response: MKETAResponse!, error:NSError!) -> Void in
                    if (nil == error)
                    {
                        let interval = (response as MKETAResponse).expectedTravelTime
                        println(interval)
                    }
                })
                
            })
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        switch (manager.desiredAccuracy) {
        case kCLLocationAccuracyThreeKilometers :
                locationmgr.desiredAccuracy = kCLLocationAccuracyKilometer
        default:
            locationmgr.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        locationmgr.stopUpdatingLocation()
        locationmgr.startMonitoringSignificantLocationChanges()
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        //centerMapOnLocation(newLocation)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString("1550 Bryant Street, San Francisco, CA", completionHandler: { (placemarks:[AnyObject]!, error:NSError!) -> Void in
            let topResult : CLPlacemark = (placemarks as? NSArray)!.objectAtIndex(0) as! CLPlacemark
            let placemark : MKPlacemark = MKPlacemark(placemark: topResult)
            
            let currentmark : MKPlacemark = MKPlacemark(coordinate: newLocation.coordinate, addressDictionary: nil)
            
            //self.mapView.addAnnotation(currentmark);
            self.centerMapOnLocation(currentmark.location);
            
        var request : MKDirectionsRequest = MKDirectionsRequest()
        //ritual coffee : 37.755185, -122.424366
        
        request.setSource(MKMapItem(placemark:currentmark) /*MKMapItem.mapItemForCurrentLocation() */)
        request.setDestination(MKMapItem(placemark: placemark))
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
                let intervalString = String(format: "%.0f:%2.0f:%.0f",intervalhr, intervalmin, intervalsec)
                self.title = intervalString
                println(intervalString)
            }
        })
    })
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
