//
//  mapViewController.swift
//  litteriOS
//
//  Created by Philip Cheek on 6/5/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    var user:User!
    var kingLocation:CLLocation! 
    var locationManager:CLLocationManager!
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topBar: UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setViewAfterLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCamSegue"{
            let target = segue.destinationViewController as! UINavigationController
            let camera = target.topViewController as! cameraViewController
            
            camera.location = self.kingLocation
            camera.user = self.user
        }
    }
    
    @IBAction func reportAreaPressed(sender: UIButton) {
        performSegueWithIdentifier("toCamSegue", sender: sender)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("HOLY SHIT")
        switch status {
        case .NotDetermined:
            print("WHWEWE")
            locationManager.requestWhenInUseAuthorization()
            break
        case .AuthorizedWhenInUse:
            print("THIS WORKS")
            self.initLocationServices()
            break
        case .AuthorizedAlways:
           self.initLocationServices()
            break
        case .Restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .Denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLocationServices(){
        mapView.showsUserLocation = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.mapView.showsUserLocation = true
        self.locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        
        if kingLocation == nil{
            self.kingLocation = location
            self.centerZoom(location)
        }else if location?.distanceFromLocation(self.kingLocation) > 1.5{
            print("significant change")
            self.kingLocation = location
        }
        
    }
    
    func setViewAfterLoad(){
        print("VALUE PASS CHECK! VALUE PASS CHECK")
        print (self.user)
        
        self.topBar.backgroundColor = UIColor.brandGreen().colorWithAlphaComponent(0.75)
        self.mapView.layoutMargins = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)

        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.kingLocation = nil
    }
    
    func checkPermission(callback:()->()){
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            callback()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Error: " + error.localizedDescription)
    }
    
    func centerZoom(location:CLLocation!){
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        self.mapView.setRegion(region, animated: true)

    }
}


