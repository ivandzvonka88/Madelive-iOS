//
//  AccountViewController.swift
//  MadeLive
//
//  Created by Mobile Dev on 30/01/20.
//  Copyright © 2020 Mobile Dev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class AccountViewController: UIViewController, NVActivityIndicatorViewable {
    
    //Global Declarations & Vars
    var userEmail = ""
    var uuid = ""
    @IBOutlet var lblUUDI: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get saved user data
        if let email = UserDefaults.standard.value(forKey: "UserEmail") as? String {
            self.userEmail = email
            self.lblEmail.text = self.userEmail
        }
        
        if let id = UserDefaults.standard.value(forKey: "UUID") as? String {
            self.uuid = id
            self.lblUUDI.text = self.uuid
        }
        
        if self.userEmail != "" && self.uuid != "" {
            self.getAccountInfo()
        }
    }
    
    //MARK: Get Account Info
    func  getAccountInfo() {
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(self.userEmail, forKey: "email")
        param.setValue(self.uuid, forKey: "uuid")
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            
            let dataObj : JSON = JSON.init(responseObject)
            if !dataObj.isNull {
                if(dataObj["response"].boolValue == true) {
                    print("Success")
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
        }
        service.PostWithAlamofire(Parameters: param as? [String : AnyObject], action: ACCOUNTAPI as NSString, success: successed, failure: failure)
    }
}
