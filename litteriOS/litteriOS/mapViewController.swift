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
    var user = [String:String]()
    var kingLocation:CLLocation!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var customBottom: UIView!
    @IBOutlet weak var customTop: UIView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewPreference()
        
        print (self.user.details)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let target = segue.destinationViewController as! UINavigationController
        let scene = target.topViewController as! CameraViewController
        scene.user = self.user
        scene.token = self.token
        scene.location = self.kingLocation
    }
    
    @IBAction func litTattle(sender: UIButton) {
        performSegueWithIdentifier("cameraSegue", sender: sender)
        
    }
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        self.kingLocation = location
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func viewPreference(){

}
