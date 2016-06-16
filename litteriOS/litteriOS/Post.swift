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
import AWSS3
import AWSCore

class Post{
    var details = [String:String]()
    
    
    func handlePostRequest(scene: UIViewController, callback:()->()){
        let posted = scene as! postViewController
        
        self.details["address"] = posted.addressTextField.text!
        self.details["authorID"] = posted.author.details["id"]! as? String
        self.details["description"] = posted.litDescript.text!
        self.details["title"] = posted.titlePost.text!
        self.details["donation"] = posted.titlePost.text!

        callback()
        self.tradeImageForUrl(posted.gallery, index: 0, callback: self.getPostToServer)
    }
    
    func getPostToServer(){
        do {
            
            print("this executing a post request")
            let jsonData = try NSJSONSerialization.dataWithJSONObject(self.details, options: NSJSONWritingOptions.PrettyPrinted)
            
            let url = NSURL(string: "http://REDACTED:5000/newPost")!
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            request.setValue("application/json; charset=utf-8",forHTTPHeaderField: "Content-Type")
            request.HTTPBody = jsonData
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let data_res = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]
                    
                    if data_res!["status"]! as! String == "success"{
                        print ("success")
                    }else{
                        print("no success")
                    }
                } catch {
                    print("Error -> \(error)")
                }
            }
            
            task.resume()
            
        }catch {
            print("Error -> \(error)")
        }

        
        
    }
    
    
    func prePopulateAddress(location:CLLocation!, callback:(String)->()){
        
        self.details["lat"] = String(location!.coordinate.latitude)
        self.details["long"] = String(location!.coordinate.longitude)
        
        let base_url = "http://api.geonames.org/findNearestAddressJSON?formatted=true&"
        let lat_url = "lat=" + self.details["lat"]! + "&"
        let lng_url = "lng=" + self.details["long"]! + "&"
        let access = "username=REDACTED&style=full/"
        
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
                            let street = result["street"]!! 
                            let town = result["placename"]!! 
                            let state = result["adminCode1"]!! 
                            let zip = result["postalcode"]!!
                            
                           
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
    
    func tradeImageForUrl(gallery:[UIImage], index:Int, callback:()->()){
        
        print("where we will call callback")
        callback()
        
        let imageName = String.random() + ".png"
        let path: NSString = NSTemporaryDirectory().stringByAppendingPathComponent(imageName)
        let imageData: NSData = UIImagePNGRepresentation(gallery[index])!
        
        print("ABOUT TO PRINT IMAGE NAME")
        print(imageName)
        
        imageData.writeToFile(path as String, atomically: true)
        
        let url:NSURL = NSURL(fileURLWithPath: path as String)
        let uploadRequest = AWSS3TransferManagerUploadRequest()

        uploadRequest?.bucket = "litterbug-resource"
        uploadRequest?.ACL = AWSS3ObjectCannedACL.PublicRead
        uploadRequest?.key = "/" + imageName
        uploadRequest?.contentType = "image/png"
        uploadRequest?.body = url;
        
        uploadRequest?.uploadProgress = {[unowned self](bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                print("total  bytes sent")
                print(totalBytesSent)
                
                print("total  bytes expected to send")
                print(totalBytesExpectedToSend)
            })
        }
        
        // now the upload request is set up we can creat the transfermanger, the credentials are already set up in the app delegate
        let transferManager:AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        // start the upload
        transferManager.upload(uploadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock:{ [unowned self]
            task -> AnyObject in
            
            // once the uploadmanager finishes check if there were any errors
            if(task.error != nil){
                print("%@", task.error);
            }else{ // if there aren't any then the image is uploaded!
                // this is the url of the image we just uploaded
                print("ATTEMPT AT URL")
                let imageURL = "https://s3.amazonaws.com/litterbug-resource/%2F" + imageName
                let key = "imageURL" + String(index)
                self.details[key] = imageURL
                
                if index == gallery.count - 1{
                    callback()
                }else{
                    self.tradeImageForUrl(gallery, index: index + 1, callback: callback)
                }
            }
            
            //self.removeLoadingView()
            print("all done");
            return ""
        })
        
    }
}
