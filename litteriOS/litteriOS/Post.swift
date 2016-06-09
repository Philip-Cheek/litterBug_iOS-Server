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
    
    //SEGUE EDIT DETAILS
    var location:CLLocation!
    var authorObjectId:String!
    var gallery:[UIImage]!
    
    //MAIN 
    var author:User = User()
}
