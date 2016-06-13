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

class postViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate{
    
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
    @IBOutlet weak var donateBody: UITextField!
    @IBOutlet weak var titlePost: UITextField!
    @IBOutlet weak var flashWarning: UILabel!
    
    
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
    
    //POST OUTLET ACTIONS
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        let valid = validation()
        if valid{
            
        }
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
    
    
    //TEXT MONITORS
    
    func textViewDidBeginEditing(textView: UITextView) {
        litDescript.text = ""
        litDescript.textColor = UIColor.blackColor()
        charCounterChange()
    }
    
    func textViewDidChange(textView: UITextView) {
        charCounterChange()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 3 && textField.text != nil{
            var decimal:Bool = false
            var idx = 0
            
            for letter in textField.text!.characters{
                if letter == "."{
                    decimal = true
                    break
                }
                idx += 1
            }
            
            if decimal == false{
                textField.text! += ".00"
            }else if idx + 1 == textField.text!.characters.count{
                textField.text! += "0"
            }
            
        }
    }
    
    func validation()->Bool{
        var warning = ""
        let donateWarning = "post must have min. donation of 1 USD"
        
        if titlePost.text?.characters.count < 5{
            warning = "Title too short"
        }else if titlePost.text?.characters.count > 500{
            warning = "Title too long"
        }else if litDescript.text.characters.count < 5{
            warning = "Please add a description"
        }else if litDescript.text.characters.count > 300{
            warning = "Description too long"
        }
        
        if donateBody.text!.characters.count < 3 || Double(donateBody.text!) < 0.0{
            if warning.characters.count == 0{
                warning = donateWarning
            }else{
                warning += " and " + donateWarning
            }
        }
        
        if warning.characters.count > 0{
            flashWarning.text = warning
                
            flashWarning.fadeIn(0.5, delay: 0.0, completion: {
                (finished: Bool) -> Void in
                print("we'reDONEWARNINGLKJSDF")
                self.flashWarning.fadeOut(0.8, delay: 1.0)
            })
            
            return false

        }else{
            return true
        }
    }
    
    //WORKER FUNCTIONS
    func setNewImageRow(){
        for idx in 0..<gallery.count{
            print(gallery[idx])
            print("about2print imagerow")
            print (imageRow[idx])
            self.imageRow[idx].image = self.gallery[idx]
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
            litDescript.textColor = UIColor.blackColor()
        }
    }
    
    func setFields(){
        self.flashWarning.alpha = 0.0
        self.severityLevel.dataSource = self
        self.severityLevel.delegate = self
        self.litDescript.delegate = self
        self.donateBody.keyboardType = .DecimalPad
        self.donateBody.text = "0.00"
        self.donateBody.textColor = UIColor.grayColor()
        self.donateBody.delegate = self
        
        
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
