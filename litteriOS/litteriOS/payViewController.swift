//
//  payViewController.swift
//  litteriOS
//
//  Created by Philip Cheek on 6/1/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import UIKit
import Stripe 

class payViewController:UIViewController, STPPaymentCardTextFieldDelegate{
    var user:User!
    
    let pTextField = STPPaymentCardTextField()
    let dTextField = STPPaymentCardTextField()
    
    @IBOutlet var topBarViews: [UIView]!
    var optionBools:[String:Bool] = [
        "bid": true,
        "paid": false,
        "debitDual": false
    ]
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var debButton: UIButton!
    @IBOutlet weak var pCardView: UIView!
    @IBOutlet weak var dCardView: UIView!
    @IBOutlet var bodyViews: [UIView]!
    @IBOutlet weak var debNot: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCardView()
    }
    
    func initCardView(){
        cardConfig(pCardView, textField: pTextField)
        cardConfig(dCardView, textField: dTextField)
        
        self.topBarViews[0].backgroundColor = UIColor.brandGreen()
        setCardView()
    }
    
    func setCardView(){
        bodyViews[0].hidden = assignBool(optionBools["bid"]!)
        
        if self.optionBools["debitDual"]! && self.optionBools["paid"]! && self.optionBools["bid"]!{
            bodyViews[1].hidden = true
        }else{
            bodyViews[1].hidden = assignBool(optionBools["paid"]!)
        }
        
        if self.optionBools["bid"]! == false||self.optionBools["paid"]! == false{
            debButton.hidden = true
            debNot.hidden = true
            self.optionBools["debitDual"] = false
        }else{
            debButton.hidden = false
        }

        
    }
    
    func cardConfig(view: UIView, textField: STPPaymentCardTextField){
        textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 30, CGRectGetHeight(view.frame))
        textField.delegate = self
        view.insertSubview(textField, atIndex:1)
    }
    
    @IBAction func topViewPressed(sender: UIButton) {
        var tag:Bool
        
        
        print (self.optionBools["bid"]!)
        
        if sender.tag == 0{
            tag = assignBool(self.optionBools["bid"]!)
            self.optionBools["bid"] = tag
        }else{
            tag = assignBool(self.optionBools["paid"]!)
            self.optionBools["paid"] = tag
        }
        
        
        if tag{
            self.topBarViews[sender.tag].backgroundColor = UIColor.brandGreen()
        }else{
            self.topBarViews[sender.tag].backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        
        setCardView()
    }
    
    func assignBool(bool:Bool)->Bool{
        if bool{
            return false
        }else{
            return true
        }
    }

    @IBAction func debButtonPressed(sender: UIButton) {
        let on:Bool = assignBool(self.optionBools["debitDual"]!)
        
        debNot.hidden = self.optionBools["debitDual"]!
        self.optionBools["debitDual"] = on
        
        print (self.optionBools)
        setCardView()
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        var cardTokens = [String:AnyObject]()
        
        func createToken(cardSubmit:STPPaymentCardTextField, type:String, done:Bool)->(){
            let card = cardSubmit.cardParams
            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                if let error = error{
                    print(error)
                }else if let token = token{
                    cardTokens[type] = token
                    if self.optionBools["debitDual"]! && type != "credit"{
                        cardTokens["recipient"] = token
                    }else if self.optionBools["debitDual"]!{
                        cardTokens["credit"] = token
                    }
                    print(cardTokens)
                    
                    
                }
            }
        }
        
        createToken(pTextField, type:"credit", done:true)

    }
    
    func retrieveToken(token:STPToken)->STPToken{
        return token
    }
    
    func sendTokensToServer(tokenData:[String:AnyObject])->(){
        print("SendTokenToServer")
        print(tokenData)
    }
        
}
