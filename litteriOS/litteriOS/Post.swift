//
//  Post.swift
//  litteriOS
//
//  Created by Philip Cheek on 6/8/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Post{
    var details = [String:String]()
    
    
    func prePopulateAddress(location:CLLocation!, callback:(String)->()){
        
        self.details["lat"] = String(location!.coordinate.latitude)
        self.details["long"] = String(location!.coordinate.longitude)
        
        let base_url = "http://api.geonames.org/findNearestAddressJSON?formatted=true&"
        let lat_url = "lat=" + self.details["lat"]! + "&"
        let lng_url = "lng=" + self.details["long"]! + "&"
        let access = "username=philipcheek&style=full/"
        
        print(base_url + lat_url + lng_url + access)
        let url = NSURL(string: base_url + lat_url + lng_url + access)!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler:{data, response, error in
            
            do {
                
                print("thisworkingwworksdfjlsdfj")
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    
                    if let result = jsonResult["address"] {
                        dispatch_async(dispatch_get_main_queue(), {
                            print ("work")
                            let street = result["street"]! as! String
                            let town = result["placename"]! as! String
                            let state = result["adminCode1"]! as! String
                            let zip = result["postalcode"]! as! String
                            
                           
                            let address = street + ", " + town + ", " + state + " " + zip
                            callback(address)
                        })
                    }
                }
            } catch {
                print("Something went wrong")
            }
        })
        task.resume()
    }
}
