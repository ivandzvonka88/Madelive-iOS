//
//  ServiceCall.swift
//  MadeLive
//
//  Created by Mobile Dev on 04/07/19.
//  Copyright © 2020 Mobile Dev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

//MARK: Show Message when no data in Table
class TableViewHelper {
    
    class func EmptyMessage(message:String, tbl:UITableView) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 300, height: 30))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        messageLabel.font = UIFont(name: "SFProText-Regular", size: 15)
        messageLabel.sizeToFit()
        tbl.backgroundView = messageLabel
        tbl.separatorStyle = .none
    }
}

//MARK: Service Call for API
class ServiceCall{
    
    //MARK: Upload data using alamofire
    func uploadWithAlamofire(Parameters params : [String: Any]?,ImageParameters imgparams :  [NSObject : AnyObject]?,VideoParameters vidoparam :  [NSObject : AnyObject]?,Action action : NSString, success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        var base_url = BASEURL
        base_url.append(action as String)
        print(base_url)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if imgparams != nil{
                for (key, value) in imgparams! {
                    if let imageData = (value as! UIImage).jpegData(compressionQuality: 0.50) {
                        multipartFormData.append(imageData, withName: key as! String, fileName: "\(NSDate().timeIntervalSince1970 * 1000)).jpg", mimeType: "image/jpg")
                    }
                }
            }
            if vidoparam != nil{
                for (key, value) in vidoparam! {
                    multipartFormData.append(value as! URL , withName: key as! String, fileName: "\(NSDate().timeIntervalSince1970 * 1000).mp4", mimeType: "application/octet-stream")
                }
            }
            if params != nil {
                for (key, value) in params! {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
            } }, to: base_url, method: .post, headers: nil,
                 encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.uploadProgress { progress in
                            print(progress.fractionCompleted)
                        }
                        upload.response { [weak self] response in
                            guard self != nil else {
                                return
                            }
                            let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                            var dictonary:NSDictionary?
                            if let data = responseString?.data(using: String.Encoding.utf8) {
                                do {
                                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                                    if dictonary != nil{
                                        print(dictonary ?? nil!)
                                        if dictonary?.value(forKey: "flag") as! NSNumber != 0{
                                            return success(dictonary!)
                                        }else{
                                            print(dictonary?.value(forKey: "flag")! as Any)
                                            return success(dictonary!)
                                        }
                                    }
                                } catch let error as NSError {
                                    print(error)
                                }
                            }
                            
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                        return failure(encodingError as AnyObject)
            }
        })
    }
    
    
    func getWebServiceCall(_ strURL : String, params : [String : AnyObject]?, isShowLoader : Bool, success : @escaping (AnyObject) -> Void,  failure :@escaping (AnyObject) -> Void){
        if AppUtilities.sharedInstance.isConnectedToNetwork() {
            var base_url = BASEURL
            base_url.append(strURL as String)
            print(base_url)
            if isShowLoader == true {
                
            }
            Alamofire.request(base_url, method: .get, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: {(resObj) -> Void in
                
                print(resObj)
                
                if resObj.result.isSuccess {
                    let responseString = String(data: resObj.data!, encoding: String.Encoding.utf8)
                    var dictonary:NSDictionary?
                    if let data = responseString?.data(using: String.Encoding.utf8) {
                        do {
                            dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                            DispatchQueue.main.async() {
                                return success(dictonary as AnyObject)
                            }
                        }catch let error as NSError {
                            print(error)
                        }
                    }
                }
                if resObj.result.isFailure {
                    let error : Error = resObj.result.error!
                    DispatchQueue.main.async() {
                        return failure(error as AnyObject)
                    }
                    
                }
            })
        }
        else {
            //KSToastView.ks_showToast(InternetMessage, duration: ToastDuration)
            AppUtilities.sharedInstance.openSettingsInternet()
        }
        
    }
    
    //MARK: POSt API Calling with Alamofire
    func PostWithAlamofire(Parameters params : [String : AnyObject]? ,action : NSString, success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void){
        var base_url = BASEURL
        base_url.append(action as String)
        print(base_url)
//        var headers : HTTPHeaders = [:]
//        if let token = UserDefaults.standard.value(forKey: "webToken"){
//            headers = ["JWT-Authorization": "Bearer \(token)"]
//        }
        
//        print(headers)
        
        if (Alamofire.NetworkReachabilityManager()?.isReachable)! {
            Alamofire.request(base_url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: "", password: "").responseSwiftyJSON { respones in
                //                dismiss
                print(respones.result.error?.localizedDescription ?? "No Error")
                
                if let json1 = respones.result.value {
                    print("json \(json1)")
                    let responseString = String(data: respones.data!, encoding: String.Encoding.utf8)
                    var dictonary:NSDictionary?
                    if let data = responseString?.data(using: String.Encoding.utf8) {
                        do {
                            dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                            DispatchQueue.main.async() {
                                return success(dictonary as AnyObject)
                            }
                        }catch let error as NSError {
                            print(error)
                        }
                    }else {
                        //KSToastView.ks_showToast(WrongMsg, duration: ToastDuration)
                        DispatchQueue.main.async() {
                            return failure(respones.result.error as AnyObject)
                        }
                        
                    }
                }else{
                    //KSToastView.ks_showToast(WrongMsg, duration: ToastDuration)
                    DispatchQueue.main.async() {
                        return failure(respones.result.error as AnyObject)
                    }
                }
            }
        }else {
            AppUtilities.sharedInstance.openSettingsInternet()
        }
        
    }
    
    //MARK: Convert text to dictionary
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
