//
//  postViewController.swift
//  litteriOS
//
//  Created by Philip Cheek on 6/8/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AVFoundation
import MapKit

class postViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{
    
    //INCOMING DETAILS 
    var location:CLLocation!
    var gallery:[UIImage]!
    var author:User!
    
    
    //POST VIEW OUTLETS
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var severityLevel: UIPickerView!
    @IBOutlet weak var litDescript: UITextView!
    @IBOutlet weak var charCounter: UILabel!
    @IBOutlet var imageRow: [UIImageView]!
    
    
    //MAIN BODY
    
    var post:Post = Post()
    var dataPicker:[String] = ["minor", "moderate", "extreme"]
    var new:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CHECKING TRANSFER DETAILS")
        print(location)
        print(author.details)
        print(gallery)
        
        self.litDescript.textColor = UIColor.grayColor()
        
        self.setNewImageRow()
        self.setMap()
        self.setFields()
    }
    
    
    //CONFIGURE SEVERITY VIEW
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPicker.count;
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPicker[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("assigning picker view")
        post.details["level"] = dataPicker[row]
        print(post.details["level"])
    }
    
    
    //TEXT VIEW MONITORS
    
    func textViewDidBeginEditing(textView: UITextView) {
        litDescript.text = ""
        litDescript.textColor = UIColor.blackColor()
        charCounterChange()
    }
    
    func textViewDidChange(textView: UITextView) {
        charCounterChange()
    }
    
    
    //WORKER FUNCTIONS
    func setNewImageRow(){
        for idx in 0..<gallery.count{
            self.imageRow[idx].image = gallery[idx]
        }
    }
    
    func charCounterChange(){
        let charLeft = 300 - litDescript.text.characters.count
        charCounter.text = "Characers left: " + String(charLeft)
        
        if charLeft < 0{
            charCounter.textColor = UIColor.redColor()
            litDescript.textColor = UIColor.redColor()
        }else if litDescript.textColor == UIColor.redColor(){
            charCounter.textColor = UIColor.blackColor()
            litDescript.textColor = UIColor.grayColor()
        }
    }
    
    func setFields(){
        self.severityLevel.dataSource = self
        self.severityLevel.delegate = self
        self.litDescript.delegate = self
        
        if self.new{
            self.litDescript.text = "Enter task description"
            self.charCounterChange()
            post.prePopulateAddress(self.location, callback: self.getAddress)
        }

    }
    
    func getAddress(addr:String){
        self.addressTextField.text = addr
    }
    
    func setMap(){
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = center
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(dropPin)
        
    }
    
   
}
