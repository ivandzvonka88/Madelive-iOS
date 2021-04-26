//
//  AppUtilites.swift
//  MadeLive
//
//  Created by Mobile Dev on 12/06/19.
//  Copyright © 2020 Mobile Dev. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration
import Kingfisher
import SafariServices

class AppUtilities{
    
    //Vars & Declarations
    var blurview : UIView = UIView()
    var selectedtabindex : Int = 0
    var homeslectservice : String  = ""
    var isInPolicyScreen : Bool = false
    var HomeSetviceList : [JSON] = []
    var Accountviewcount : Int = 1
    var arrCounrty: NSArray = []
    var arrAllCounrtyData: NSArray = []
    
    //Class Instance
    class var sharedInstance : AppUtilities {
        struct Singleton {
            static let instance = AppUtilities()
        }
        
        return Singleton.instance
    }
    
    //MARK: Open URL in Browser
    func openWeb(url : String) -> SFSafariViewController {
        let safari : SFSafariViewController
        let urlNew = URL(string: url)
        if #available(iOS 11.0, *) {
            safari = SFSafariViewController(url: urlNew!)
        } else {
            safari = SFSafariViewController(url: urlNew!, entersReaderIfAvailable: true)
        }
        safari.preferredControlTintColor = UIColor.init(red: 59/255, green: 124/255, blue: 255/255, alpha: 1)
        return safari
    }
    
    //MARK: Set Corner Radius for View
    func setViewCorner(viewMain  : UIView, radius :  CGFloat) {
        viewMain.layer.cornerRadius = radius
        viewMain.clipsToBounds = true
    }
    
    //MARK: Date Formatter
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return "     -     "
    }
    
    //MARK: Add dotted Line
    func addDottedLineInLabel(label : UILabel , color: UIColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [5,2]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0 , y: 0),
                                CGPoint(x: 0, y: label.frame.size.height)])
        
        shapeLayer.path = path
        label.layer.addSublayer(shapeLayer)
    }
    
    //MARK: Add Spacing in Label
    func addSpacingLabelText(_ label: UILabel, string title: String) {
        let string: String = title
        let attributedString = NSMutableAttributedString(string: string)
        let spacing: Float = 3.0
        attributedString.addAttribute(NSAttributedString.Key.kern, value: (spacing), range: NSRange(location: 0, length: (title.count)))
        label.attributedText = attributedString
    }
    
    //MARK: Line Spacing in Label
    func setLineSpacing(_ label: UILabel , lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = label.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = .center
        let attributedString:NSMutableAttributedString
        if let labelattributedText = label.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        label.attributedText = attributedString
    }
    
    //MARK: Set Underline in Label
    func SetUnderLine(lbl: UILabel ,arrSearch : NSArray ,linespace : CGFloat){
        let attrStr = NSMutableAttributedString(string: lbl.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = linespace
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrStr.length))
        
        let inputLength = attrStr.string.count
        let searchString : NSArray =  arrSearch 
        for i in 0...searchString.count-1
        {
            let string : String = searchString.object(at: i) as! String
            let searchLength = string.count
            var range = NSRange(location: 0, length: attrStr.length)
            while (range.location != NSNotFound) {
                range = (attrStr.string as NSString).range(of: string, options: [], range: range)
                if (range.location != NSNotFound) {
                    let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
                    attrStr.addAttribute(NSAttributedString.Key.link, value: underlineAttribute, range: NSRange(location: range.location, length: searchLength))
                    attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location: range.location, length: searchLength))
                    range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
                    lbl.attributedText = attrStr
                }
            }
        }
    }
    
    //MARK: Zoom Animation
    func animateZoomforCell(zoomCell : UICollectionViewCell)
    {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: {
                zoomCell.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        },
            completion: nil)
    }
    
    //MARK: Zoon Animation for Removal
    func animateZoomforCellremove(zoomCell : UICollectionViewCell)
    {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: {
                zoomCell.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        },
            completion: nil)
        
    }
    
    //MARK: View Shadows
    func ViewShadows(View: UIView) {
        View.layer.shadowColor = CELL_BORDER_COLOR.cgColor
        View.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        View.layer.shadowOpacity = 1.0
        View.layer.shadowRadius = 3.0
        View.layer.shouldRasterize = false
        View.layer.masksToBounds = false
    }
    
    //MARK: Remove Animation
    func removeAnimate(View1: UIView) {
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            View1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            View1.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
            if finished {
                View1.isHidden = true
            }
            else{
                View1.isHidden = true
            }
        })
    }
    
    //MARK: Animation for Popup
    func addPopUpZoomAnimatioToPickerView(view: UIView) {
        
        view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        view.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
    
    //MARK: Add Blur View
    func addBlurView(view: UIView) {
        blurview.frame =  CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        blurview.backgroundColor = UIColor.black
        blurview.layer.opacity = 0.5
        view.addSubview(blurview)
    }
    
    //MARK: Remove Blur View
    func RemoveBlurView(view: UIView) {
        blurview.removeFromSuperview()
    }
    
    //MARK: Set Attributed Label
    func SetBoldColorChangetoLabel(label: UILabel ,SearchText: NSArray ,Boldattribute: [NSAttributedString.Key:Any],Colorattribute: [NSAttributedString.Key:Any]){
        let attrStr = NSMutableAttributedString(string: label.text!)
        
        let inputLength = attrStr.string.count
        
        for i in 0...SearchText.count-1
        {
            let string : String = SearchText.object(at: i) as! String
            let searchLength = string.count
            var range = NSRange(location: 0, length: attrStr.length)
            while (range.location != NSNotFound) {
                range = (attrStr.string as NSString).range(of: string, options: [], range: range)
                if (range.location != NSNotFound) {
                    
                    attrStr.addAttributes(Boldattribute, range: NSRange(location: range.location, length: searchLength))
                    attrStr.addAttributes(Colorattribute, range: NSRange(location: range.location, length: searchLength))
                    
                    range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
                    label.attributedText = attrStr
                }
            }
        }
    }
    
    //MARK: Table Animation
    func animateTable(table: UITableView) {
        table.reloadData()
        
        let cells = table.visibleCells
        let tableHeight: CGFloat = table.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    //MARK: Check Connectivity
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    //MARK: Set Button padding
    func SetButtonPaddig(btn:UIButton){
        btn.contentHorizontalAlignment = .left;
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
    }
    
    //MARK: - Validation
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    //MARK: Check for special characters
    func hasSpecialCharacters(str : String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9 ].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, str.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    //MARK: Check for Phone Validation
    func isValidPhone(phone: String) -> Bool
    {
        let PHONE_REGEX = "^[0-9]{7,14}$" // "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        return result
    }
    
    //MARK: Check for email Validation
    func isValidEmail(emailAddressString:String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    //MARK: Get TimeStamp String
    func timeStampConvertToDate(strStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: strStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    //MARK: Set Shadow View
    func setShadowOnView(viewM : UIView){
        viewM.layer.masksToBounds = false
        viewM.layer.shadowOpacity = 1
        viewM.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        viewM.layer.shadowRadius = 15.0
        viewM.layer.shadowColor = UIColor.init(red: 234/255, green: 236/255, blue: 249/255, alpha: 1.0).cgColor
    }
    
    //MARK: Convert to Currency
    func convertToCurrency(strPrice : Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        let priceString = currencyFormatter.string(from: NSNumber.init(value: strPrice))
        return priceString!
    }
    
    //MARK: Convert to Thousands
    func convertToThousands(strPrice : Int64) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        let priceString = currencyFormatter.string(from: NSNumber.init(value: strPrice))
        return priceString!
    }
    
    //MARK: Get Country Data
    func getCountryData() -> NSArray {
        let fileName:String = Bundle.main.path(forResource: "dataImages", ofType: "json")!
        let partyData = NSData(contentsOfFile: fileName)
        do { 
            let json:NSDictionary = try JSONSerialization.jsonObject(with: partyData! as Data, options: []) as! NSDictionary
            if let dataCountry : NSArray = json.object(forKey: "countries") as? NSArray {
                arrCounrty = dataCountry
                arrAllCounrtyData = arrCounrty
            }
            
        } catch {}
        return arrAllCounrtyData
    }
    
    //MARK: Show ALert when No Internet is Found
    func openSettingsInternet() {
        showAlert("No Internet", message: "No internet connection, please try again later")
    }
    
    //MARK: Show Option to Open Setting with Alert
    func showAlert(_ title:String , message:String) {
        let alertController = UIAlertController (title: title,  message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
    }
}


