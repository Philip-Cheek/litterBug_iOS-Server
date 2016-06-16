//
//  ViewController.swift
//  litteriOS
//
//  Created by Philip Cheek on 5/27/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation


class introViewController: UIViewController, FBSDKLoginButtonDelegate{
    var user:User = User()
    var login_clicked:Bool = false
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var rWing: UIImageView!
    @IBOutlet weak var lWing: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcome.hidden = true
        self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        self.loginButton.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.wingFlap()
        if (FBSDKAccessToken.currentAccessToken() != nil && login_clicked == false){
            //self.loginButton.hidden = true
            //self.welcome.hidden = false
            print("let'so")
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil){
                    print("Error: \(error)")
                }else {
                    print("whatwhat")
                    let fb = ["id": result["id"]!! as! String]
                    print (fb)
                    self.user.login(fb, callback: self.performSegue)
                }
            })
            
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("what the fuck")
        if segue.identifier == "initPaySegue"{
            let pay = segue.destinationViewController as! payViewController
            pay.user = self.user
        }else{
            let target = segue.destinationViewController as! UITabBarController
            let map = target.viewControllers![0] as! mapViewController
            map.user = self.user
        }
    }
    
    
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil
        {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error) != nil{
                    
                    print("Error: \(error)")
                    
                }else{
                    self.login_clicked = true
                    self.user.login(result, callback: self.performSegue)
                }
                    
            })
        }
        else
        {
            print(error.localizedDescription)
        }
        }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Loged out...")
    }
    
    func performSegue()->(){
        print("we would perform segue here")
        print ("will print details")
        print(self.user.details)
        
        if self.user.details["customerID"]! as! String == "none" || self.user.details["paymentID"]! as! String == "none"{
            performSegueWithIdentifier("initPaySegue", sender: self)
        }else{
            print("here we would segue to mapViewController")
            
            performSegueWithIdentifier("initMapSegue", sender: self)
        }
    }
    
    func wingFlap()->(){
        getAnchor(CGPointMake(1, 0.95), view: lWing)
        getAnchor(CGPointMake(0.3,1), view: rWing)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options:[.Repeat, .Autoreverse], animations: {
            self.lWing.transform = CGAffineTransformMakeRotation((358 * CGFloat(M_PI)) / 180.0)
            self.rWing.transform = CGAffineTransformMakeRotation((3 * CGFloat(M_PI))/180.0)
            }, completion: nil
        )

        
        
    }
    
    func getAnchor(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position : CGPoint = view.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }


}

