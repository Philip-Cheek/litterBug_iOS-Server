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
    @IBOutlet var imageRow: [UIImageView]!
    @IBOutlet weak var donateBody: UITextField!
    @IBOutlet weak var titlePost: UITextField!
    @IBOutlet weak var flashWarning: UILabel!
    @IBOutlet var charCounter: [UILabel]!
    
    
    //MAIN BODY
    
    var post:Post = Post()
    var dataPicker:[String] = ["minor", "moderate", "extreme"]
    var new:Bool = true
    var submit:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CHECKING TRANSFER DETAILS")
        print(location)
        print(author.details)
        print(gallery)
        
        hideKeyboardWhenTappedAround()
        self.setFields()

        self.titlePost.addTarget(self, action: #selector(postViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)

        self.litDescript.textColor = UIColor.grayColor()
        
        self.setNewImageRow()
        self.setMap()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if submit{
            let scene = segue.destinationViewController as! submitViewController
            scene.user = self.author
        }
    }
    
    //POST OUTLET ACTIONS
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        let valid = validation()
        if valid{
            print("okay")
            //self.post.tradeImageForUrl(gallery[0], callback: self.performSubmitSegue)
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
        if litDescript.text == "Enter task description"{
            litDescript.text = ""
            litDescript.textColor = UIColor.blackColor()
        }
        
        charCounterChange(1)
    }
    
    func textViewDidChange(textView: UITextView) {
        charCounterChange(1)
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 3 && textField.text != nil{
            print("OKay")
            var decimal:Bool = false
            var idx = 0
            
            for letter in textField.text!.characters{
                idx += 1
                
                if letter == "."{
                    decimal = true
                    break
                }
            }
            
            if decimal == false{
                textField.text! += ".00"
            }else if idx + 1 == textField.text!.characters.count{
                textField.text! += "0"
            }
            
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "0.00"{
            textField.text = ""
        }
    }
    func textFieldDidChange(textField:UITextField){
        self.charCounterChange(0)
    }
    
    func validation()->Bool{
        print ("we made it to validations->hunting4nil")
        var warnings = [String]()
        
        if titlePost.text?.characters.count < 5{
            warnings.append("Title too short")
        }else if titlePost.text?.characters.count > 500{
            warnings.append("Title too long")
        }
        
        if litDescript.text.characters.count < 5 || litDescript.text == "Enter task description"{
            warnings.append("Please add a description")
        }else if litDescript.text.characters.count > 300{
            warnings.append("Description too long")
        }
        
        if donateBody.text!.characters.count < 3 || Double(donateBody.text!) < 1.0{
            warnings.append("post must have min. donation of 1 USD")
        }
        
        if warnings.count > 0{
            var iteration = 0.0
            
            for warning:String in warnings{
                let dLay = 2.2 * iteration
                
                delay(dLay){
                
                    self.flashWarning.text = warning
                
                    self.flashWarning.fadeIn(0.5, delay: 0.0, completion: {
                        (finished: Bool) -> Void in
                        print("we'reDONEWARNINGLKJSDF")
                        self.flashWarning.fadeOut(0.8, delay: 1.0)
                    })
                }
                
                iteration += 1.0
            }
            
            return false

        }else{
            return true
        }
    }
    
    //WORKER FUNCTIONS
    
    func performSubmitSegue(){
        self.submit = true
        performSegueWithIdentifier("submitSegue", sender: self)
        
    }
    
    func setNewImageRow(){
        for idx in 0..<gallery.count{
            print(gallery[idx])
            print("about2print imagerow")
            print (imageRow[idx])
            self.imageRow[idx].image = self.gallery[idx]
        }
    }
    
    func charCounterChange(whichField:Int){
        print("counter change called")
        
        var limit:Int!
        var textChunk:String!
        var color:UIColor
        
        if whichField == 1{
            limit = 300
            print("worsks at limit for whichField 1")
            textChunk = self.litDescript.text
            print("works at TextChunk for whichField 1")
            color = self.litDescript.textColor!
        }else{
            limit = 60
            print("works at limit")
            textChunk = self.titlePost.text
            print("works at textChunk")
            color = self.titlePost.textColor!
            print("do we get to color")

        }
        
        print("TEST LIMIT")
        print(limit)
        
        func colorSwitchForSwiftType(toColor:UIColor){
            if whichField == 1{
                self.litDescript.textColor = toColor
            }else{
                self.titlePost.textColor = toColor
            }
        }
        

        let charLeft = limit - textChunk.characters.count
        self.charCounter[whichField].text = "Character Count: " + String(charLeft)
            
        if charLeft < 0{
            self.charCounter[whichField].textColor = UIColor.redColor()
            colorSwitchForSwiftType(UIColor.redColor())
        }else if color == UIColor.redColor(){
            self.charCounter[whichField].textColor = UIColor.blackColor()
            colorSwitchForSwiftType(UIColor.blackColor())

        }
    }
    
    func setFields(){
        self.flashWarning.alpha = 0.0
        self.severityLevel.dataSource = self
        self.severityLevel.delegate = self
        self.litDescript.delegate = self
        self.litDescript.textColor = UIColor.blackColor()
        self.donateBody.keyboardType = .DecimalPad
        self.donateBody.text = "0.00"
        self.donateBody.textColor = UIColor.grayColor()
        self.donateBody.delegate = self
        
        
        if self.new{
            self.litDescript.text = "Enter task description"
            post.prePopulateAddress(self.location, callback: self.getAddress)
        }
        
        
        for i in 0...1{
            print(i)
            self.charCounterChange(i)
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
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    
   
}
