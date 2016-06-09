//
//  uiViewExtentions.swift
//  litteriOS
//
//  Created by Philip Cheek on 6/4/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

