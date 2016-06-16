//
//  submitViewController.swift
//  litteriOS
//
//  Created by Philip Cheek on 6/14/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import Foundation
import UIKit

class submitViewController:UIViewController{
    
    //INCOMING DETAILS
    var user:User!
    
    
    //MAIN BODY
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CHECKING SUBMIT USER DETAILS")
        print (self.user.details)
        
        delay(2.0){
            self.performSegueWithIdentifier("backToHome", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare to send back to map")
        let target = segue.destinationViewController as! UITabBarController
        let map = target.viewControllers![0] as! mapViewController
        map.user = self.user
    }
    
    //WORKER FUNCTIONS
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}