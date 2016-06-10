//
//  newPostViewController.swift
//  litteriOS
//
//  Created by Philip Cheek on 6/7/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class cameraViewController:UIViewController{
    
    //INCOMING DETAILS 
    var user:User!
    var camera:Camera!
    var location:CLLocation!
    
    
    //CAMERA VIEW OUTLETS
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var jumboPreview: UIImageView!
    @IBOutlet var imageRow: [UIImageView]!
    @IBOutlet var parentViews: [UIView]!
    @IBOutlet var subViews: [UIView]!
    @IBOutlet weak var camBottomBar: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet var camBottomBarButtons: [UIButton]!
    @IBOutlet weak var warning: UILabel!
    
    
    //MAIN BODY 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Printing location. Make sure. Make sure.")
        print (self.location)
        initMasterView()
        camera = Camera(previewView:self.previewView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        camera.initCameraPreview()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.userInteractionEnabled = true
        camera.setPreviewBounds()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postSegue"{
            let scene = segue.destinationViewController as! postViewController
            scene.location = self.location
            scene.gallery = self.camera.imageCollection
            scene.author = self.user
            
        }
    }
    
    
    //CAMERA VIEW ACTIONS
    
    @IBAction func useJumboPreview(sender: UIButton) {
        if self.camera.imageCollection.count < 3{
            sender.enabled = false
            self.camera.imageCollection.append(self.jumboPreview.image!)
            self.imageRow[self.imageCollectionCount()].image = self.jumboPreview.image
            self.imageRow[self.imageCollectionCount()].layer.borderColor = UIColor.brandBlue().CGColor
        }else{
            self.displayWarning("over")
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func takePhotoPressed(sender: UIButton) {
        camera.takePhoto(self.setAJumboPreview)
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        print (self.camera.imageCollection.count)
        if self.camera.imageCollection.count < 1{
            self.displayWarning("under")
        }else{
            performSegueWithIdentifier("postSegue", sender: self)
        }
    }
    
    @IBAction func discardPhoto(sender: UIButton) {
        var swap = -2
        var delete = -2
        
        for idx in 0..<camera.imageCollection.count{
            if jumboPreview.image! == camera.imageCollection[idx]{
                print ("match")
                self.setImageRowItemToBlank(idx)
                swap = idx
                delete = swap
                print("Printing swap: " + String(swap))
            }else if swap == idx - 1{
                print("About to swap")
                print("Printing swap: " + String(swap))
                
                imageRow[swap].image = imageRow[idx].image!
                self.setImageRowItemToBlank(idx)
                imageRow[swap].layer.borderColor = UIColor.whiteColor().CGColor
                swap += 1
            }
        }
        
        if delete >= 0{
           self.camera.imageCollection.removeAtIndex(delete)
        }
        
        self.resetCamera()
    }
    
    @IBAction func newPhoto(sender: UIButton) {
        self.resetCamera()
        for imageView:UIImageView in self.imageRow{
            imageView.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    
    //WORKER FUNCTIONS
    
    func initMasterView(){
        self.warning.alpha = 0.0
        self.setImageRow()
        self.addGesturesToImageRow()
        self.camBottomBar.backgroundColor = UIColor.brandBlue().colorWithAlphaComponent(0.5)
        self.camBottomBar.hidden = true
    }
    
    func setAJumboPreview(image:UIImage){
        self.jumboPreview.image = image
        self.camBottomBar.hidden = false
        self.takePhotoButton.hidden = true
        
    }
    
    func setImageRowItemToBlank(index:Int){
        self.imageRow[index].image = nil
        self.imageRow[index].layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func resetCamera(){
        self.jumboPreview.image = nil
        camBottomBar.hidden = true
        takePhotoButton.hidden = false
        for button:UIButton in camBottomBarButtons{
            button.enabled = true
        }
    }
    
    func imageCollectionCount()->Int{
        var count = self.camera.imageCollection.count
        if count > 0{
            count -= 1
        }
        return count
    }
    
    func displayWarning(type:String){
        if type == "over"{
            self.warning.text = "Photo limit reached."
        }else{
            self.warning.text = "You must use at least one photo."
        }
        print("warningcalled!!")
        self.warning.fadeIn(0.5, delay: 0.0, completion: {
            (finished: Bool) -> Void in
            print("we'reDONEWARNINGLKJSDF")
            self.warning.fadeOut(0.8, delay: 1.0)
        })
        
    }
    
    
    //FUNCTIONALITY FOR IMAGE ROW

    func addGesturesToImageRow(){
        for image:UIImageView in self.imageRow{
            let didTap = UITapGestureRecognizer(target:self, action: #selector(self.didTapImage))
            print("addingimage")
            print (image.tag)
            image.addGestureRecognizer(didTap)
        }
    }
    
    func didTapImage(sender:UITapGestureRecognizer!){
        print("thisshouldwork)")
        
        for image:UIImageView in self.imageRow{
            if image != image.tag{
                image.layer.borderColor = UIColor.whiteColor().CGColor
                
            }
        }
        
        if let imageView = sender.view as? UIImageView{
            if imageView.image != nil{
                if jumboPreview.image != nil && jumboPreview.image! == imageView.image!{
                    imageView.layer.borderColor = UIColor.whiteColor().CGColor
                    resetCamera()
                }else{
                    imageView.layer.borderColor = UIColor.brandBlue().CGColor
                    self.setAJumboPreview(imageView.image!)
                }
                
            }else{
                resetCamera()
            }
        }
    }
    
    func setImageRow(){
        for idx in 0..<self.imageRow.count{
            let image = imageRow[idx]
            
            parentViews[idx].bringSubviewToFront(image)
            image.layer.cornerRadius = image.frame.size.width/2
            image.layer.masksToBounds = true
            image.layer.borderWidth = 5
            image.layer.borderColor = UIColor.whiteColor().CGColor
            
            
        }
    }

    

}
