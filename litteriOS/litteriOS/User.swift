//
//  User.swift
//  litteriOS
//
//  Created by Philip Cheek on 5/27/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import Foundation

class User{
    var details:[String:AnyObject] = [
        "name": "",
        "fb": "",
        "id": "",
        "ageRange": "",
        "gender": "",
        "pic": "",
        "email": "",
        "customerID": "none",
        "paymentID": "none"
    ]
    
    func create(info: AnyObject?, callback:() -> ()){
        detailInjection(info)
        
        print("DETAILS CHECK")
        print(self.details)
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(self.details, options: NSJSONWritingOptions.PrettyPrinted)
            
            let url = NSURL(string: "http://192.168.1.2:5000/create")!
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
                    
                    if data_res!["status"]! as! String == "logged"{
                        print ("logged")
                        
                        self.details["id"] = data_res!["id"]! as? String
                        callback()
                    }else{
                        print("not logged")
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
    
    func login(info:AnyObject?, callback:()->()){
        let fb = ["fb": (info!["id"]! as? String)!]
        print("WEBMADKEW IT")
        print(fb)
        print(info)
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(fb, options: NSJSONWritingOptions.PrettyPrinted)
            
            let url = NSURL(string: "http://192.168.1.2:5000/login")!
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
                    
                    if data_res!["status"]! as! String == "logged"{
                        print ("logged")
                        
                        let user_details = data_res!["user"]!
                        self.detailInjection(user_details)
                        callback()
                        
                    }else{
                        print(info)
                        self.create(info, callback: callback)
                    }
                } catch {
                    print("Error -> \(error)")
                }
            }
            
            task.resume()
            
        } catch {
            print(error)
        }

    }
    
    func detailInjection(info: AnyObject?){
        self.details = [
            "name": info!["name"]!! as! String,
            "gender": info!["gender"]!! as! String,
            "email": info!["email"]!! as! String
        ]
            
        if info!["id"]! != nil{
            self.details["fb"] = info!["id"]!! as? String
            self.details["ageRange"] = String(info!["age_range"]!!["min"]!!)
            self.details["pic"] = info!["picture"]!!["data"]!!["url"]! as? String
            self.details["customerID"] = "none"
            self.details["paymentID"] = "none"
        }else{
            self.details["fb"] = info!["fb"]!! as? String
            self.details["id"] = info!["_id"]!! as? String
            self.details["ageRange"] = info!["ageRange"]!! as? String
            self.details["pic"] = info!["pic"]! as? String
            
            let paymentDetails:[String] = ["customerID", "paymentID"]
            
            for ID in 0...1{
               let paymentDetail = paymentDetails[ID]
               if let payType = info![paymentDetail]!! as? String{
                    self.details[paymentDetail] = payType
               }
                
                    
            }
            
        }
            
        
    }
}
