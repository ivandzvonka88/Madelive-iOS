//
//  Global.swift
//  MadeLive
//
//  Created by Mobile Dev on 12/13/19.
//  Copyright © 2020 Mobile Dev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON
import NVActivityIndicatorView
import Photos
import Foundation

//MARK: Button Left Alignment
@IBDesignable
class LeftAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        let availableWidth = bounds.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2, bottom: 0, right: 0)
    }
}

//MARK: Button Right Alignment
@IBDesignable
class RightAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        let availableWidth = bounds.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth  - 10)
    }
}

//MARK: View Extension to Set Runtime Attributes
@IBDesignable class CustomView : UIView {
    var isshadows : Bool = false
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.myProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.myProperty()
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var isShadow: Bool = false {
        didSet {
            self.isshadows = isShadow
            self.myProperty()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    func myProperty()
    {
        if self.isshadows{
            self.addShadow()
        }
        
    }
    func addShadow() {
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red:0.39, green:0.44, blue:0.69, alpha:0.14).cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 3)
        self.layer.shouldRasterize = true
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 2.0
        self.layer.shouldRasterize = false
    }
}

//MARK: Navigation Extension
extension UINavigationController {
    func backToViewController(viewController: Swift.AnyClass) {
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}

class Global: NSObject {
    
}

//MARK: Textfield Extension
@IBDesignable
public class KTextField: UITextField {
    // MARK: - IBInspectable properties
    /// Applies border to the text view with the specified width
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
        }
    }
    /// Sets the color of the border
    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    /// Make the corners rounded with the specified radius
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    /// Applies underline to the text view with the specified width
    @IBInspectable public var underLineWidth: CGFloat = 0.0 {
        didSet {
            updateUnderLineFrame()
        }
    }
    
    /// Sets the placeholder color
    @IBInspectable public var placeholderColor: UIColor = .lightGray {
        didSet {
            let placeholderStr = placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    public override var placeholder: String? {
        didSet {
            let placeholderStr = placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    /// Sets left margin
    @IBInspectable public var leftMargin: CGFloat = 10.0 {
        didSet {
            setMargins()
        }
    }
    /// Sets right margin
    @IBInspectable public var rightMargin: CGFloat = 10.0 {
        didSet {
            setMargins()
        }
    }
    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyStyles()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyles()
    }
    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateUnderLineFrame()
        updateAccessoryViewFrame()
    }
    // MARK: - Styles
    private func applyStyles() {
        applyUnderLine()
        setMargins()
    }
    // MARK: - Underline
    private var underLineLayer = CALayer()
    private func applyUnderLine() {
        // Apply underline only if the text view's has no borders
        if borderStyle == UITextField.BorderStyle.none {
            underLineLayer.removeFromSuperlayer()
            updateUnderLineFrame()
            updateUnderLineUI()
            layer.addSublayer(underLineLayer)
            layer.masksToBounds = true
        }
    }
    private func updateUnderLineFrame() {
        var rect = bounds
        rect.origin.y = bounds.height - underLineWidth
        rect.size.height = underLineWidth
        underLineLayer.frame = rect
    }
    private func updateUnderLineUI() {
        
    }
    // MARK: - Margins
    private var leftAcessoryView = UIView()
    private var rightAcessoryView = UIView()
    private func setMargins() {
        // Left Margin
        leftView = nil
        leftViewMode = .never
        if leftMargin > 0 {
            if nil == leftView {
                leftAcessoryView.backgroundColor = .clear
                leftView = leftAcessoryView
                leftViewMode = .always
            }
        }
        updateAccessoryViewFrame()
        // Right Margin
        rightView = nil
        rightViewMode = .never
        if rightMargin > 0 {
            if nil == rightView {
                rightAcessoryView.backgroundColor = .clear
                rightView = rightAcessoryView
                rightViewMode = .always
            }
            updateAccessoryViewFrame()
        }
    }
    private func updateAccessoryViewFrame() {
        // Left View Frame
        var leftRect = bounds
        leftRect.size.width = leftMargin
        leftAcessoryView.frame = leftRect
        // Right View Frame
        var rightRect = bounds
        rightRect.size.width = rightMargin
        rightAcessoryView.frame = rightRect
    }
}

//MARK: Check Device Version & Name
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
        
    }
    
}

//MARK: Button Extension to set Attributes
@IBDesignable class CustomButton : UIButton {
    var isshadows : Bool = false
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            self.isshadows = isShadow
            self.myProperty()
        }
    }
    
    func myProperty()
    {
        if self.isshadows{
            self.addShadow()
        }
        
    }
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red:0.39, green:0.44, blue:0.69, alpha:0.14).cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 3)
        self.layer.shouldRasterize = true
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 2.0
        self.layer.shouldRasterize = false
    }
    
}

//MARK: View Extension
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

//MARK: Dashed Line for View
class DashedLineView: UIView {
    
    private let borderLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        borderLayer.strokeColor = UIColor.init(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0).cgColor
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 2
        borderLayer.lineJoin = CAShapeLayerLineJoin.round
        borderLayer.lineDashPattern = [3,3]
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame.size = CGSize.init(width: 3, height: 10)
        borderLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2, height: 5), cornerRadius: self.layer.cornerRadius).cgPath
        layer.addSublayer(borderLayer)
    }
    
    override func draw(_ rect: CGRect) {
        
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
    }
}

@available(iOS 13.0, *)
func drawRedBorderToTextfield(txtField:AnyObject, cornerRadius:CGFloat, borderRadius:CGFloat) {
    txtField.layer.borderWidth=borderRadius
    txtField.layer.cornerRadius=cornerRadius
    txtField.layer.masksToBounds = true
    txtField.layer.borderColor=UIColor.red.cgColor
}

@available(iOS 13.0, *)
func drawClearBorderToTextfield(txtField:AnyObject,cornerRadius:CGFloat, borderRadius:CGFloat) {
    txtField.layer.borderWidth=borderRadius
    txtField.layer.cornerRadius=cornerRadius
    txtField.layer.masksToBounds = true
    txtField.layer.borderColor=UIColor.clear.cgColor
}

func setViewCorner(viewMain  : UIView, radius :  CGFloat) {
    viewMain.layer.cornerRadius = radius
    viewMain.clipsToBounds = true
}

func labelSize(for text: String,fontSize: CGFloat, maxWidth : CGFloat,numberOfLines: Int) -> CGRect{
    
    let font = UIFont.init(name: "SanFranciscoText-Bold", size: fontSize)
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.leastNonzeroMagnitude))
    label.numberOfLines = numberOfLines
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame
}

//MARK: Scrollview Extension
extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}


//MARK: -  Validation Data Class
class ValidationClass: NSObject {
    
    func isEmptyVal(stringValue: NSString) -> Bool {
        if stringValue.length==0 || stringValue=="" || stringValue=="NULL" || stringValue=="(null)" || stringValue=="<null>"
            //            || stringValue==NSNull()
        {
            return true
        }
        else
        {
            return false
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func validatePhoneNumber(value: String) -> Bool {
        
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    func isValidPassword(passwordValue:String) -> Bool
    {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{6,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: passwordValue)
    }
    
    func Alert(_ title: String, message: String, vc: UIViewController) -> UIAlertController
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        return alert
    }
    
}

//MARK: Keyboard Extension Func
class KeyboardService: NSObject {
    static var serviceSingleton = KeyboardService()
    var measuredSize: CGRect = CGRect.zero
    
    @objc class func keyboardHeight() -> CGFloat {
        let keyboardSize = KeyboardService.keyboardSize()
        return keyboardSize.size.height
    }
    
    @objc class func keyboardSize() -> CGRect {
        return serviceSingleton.measuredSize
    }
    
    private func observeKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.keyboardChange), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func observeKeyboard() {
        let field = UITextField()
        UIApplication.shared.windows.first?.addSubview(field)
        field.becomeFirstResponder()
        field.resignFirstResponder()
        field.removeFromSuperview()
    }
    
    @objc private func keyboardChange(_ notification: Notification) {
        guard measuredSize == CGRect.zero, let info = notification.userInfo,
            let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        
        measuredSize = value.cgRectValue
    }
    
    override init() {
        super.init()
        observeKeyboardNotifications()
        observeKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIApplication {
    
    /*var statusBarView: UIView? {
     return value(forKey: "statusBar") as? UIView
     }*/
    
}

extension String {
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
}

//MARK: Check Permission for Accessing Library
func checkPermission() -> Bool{
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    switch photoAuthorizationStatus {
    case .authorized:
        print("Access is granted by user")
        return true
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            print("status is \(newStatus)")
            if newStatus ==  PHAuthorizationStatus.authorized {
                /* do stuff here */
                print("success")
                
            }
        })
        print("It is not determined until now")
        return false
        
    case .restricted:
        // same same
        print("User do not have access to photo album.")
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            print("status is \(newStatus)")
            if newStatus ==  PHAuthorizationStatus.authorized {
                /* do stuff here */
                print("success")
                
            }
        })
        return false;
    case .denied:
        // same same
        print("User has denied the permission.")
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            print("status is \(newStatus)")
            if newStatus ==  PHAuthorizationStatus.authorized {
                /* do stuff here */
                print("success")
                
            }
        })
        return false;
    default:
        print("default")
        return false;
    }
}

//MARK: String Extension
extension String {
    
    func isInt() -> Bool {
        
        if let intValue = Int(self) {
            
            if intValue >= 0 {
                return true
            }
        }
        
        return false
    }
    
    func isFloat() -> Bool {
        
        if let floatValue = Float(self) {
            
            if floatValue >= 0 {
                return true
            }
        }
        return false
    }
    
    func isDouble() -> Bool {
        if let doubleValue = Double(self) {
            
            if doubleValue >= 0 {
                return true
            }
        }
        return false
    }
    
}

//MARK: String Extension
extension String {
    var chomp : String {
        mutating get {
            self.remove(at: self.startIndex)
            return self
        }
    }
}

//MARK: Data Textfield
extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/doc",
        0x46 : "text/plain",
        0xEC : "application/msword",
        0x09 : "application/excel",
        0xFD : "application/mspowerpoint",
        0x7B : "application/rtf",
        0x72 : "text/xml",
        0x50 : "application/docx"
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}

//MARK: Date Extension
extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

//MARK: String Extension
extension String {
    
    func UnderLineWordsIn(UnderLineWordsIn: String, attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: UnderLineWordsIn)
        let result = NSMutableAttributedString(string: self)
        result.addAttributes(attributes, range: range)
        // let welcomeAttrString = NSMutableAttributedString(string: UnderLineWordsIn, attributes: attributes)
        //  result.append(welcomeAttrString)
        return result
    }
    
}

//MARK: Textfield Extension
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

//MARK: Textfield Extension func
class CustomTextFieldWithImage: UITextField {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return super.leftViewRect(forBounds: bounds)
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var imageMaxHeight: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            
            let containerSize = calculateContainerViewSize(for: image)
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerSize.width, height: containerSize.height))
            
            let imageView = UIImageView(frame: .zero)
            containerView.addSubview(imageView)
            setImageViewConstraints(imageView, in: containerView)
            
            setImageViewProperties(imageView, image: image)
            
            leftView = containerView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "",
                                                   attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    private func calculateContainerViewSize(for image: UIImage) -> CGSize {
        let imageRatio = image.size.height / image.size.width
        let adjustedImageMaxHeight = imageMaxHeight > self.frame.height ? self.frame.height : imageMaxHeight
        
        var imageSize = CGSize()
        if image.size.height > adjustedImageMaxHeight {
            imageSize.height = adjustedImageMaxHeight
            imageSize.width = imageSize.height / imageRatio
        }
        
        let paddingWidth = leftPadding + rightPadding
        
        let containerSize = CGSize(width: imageSize.width + paddingWidth, height: imageSize.height)
        return containerSize
    }
    
    private func setImageViewConstraints(_ imageView: UIImageView, in containerView: UIView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -rightPadding).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding).isActive = true
    }
    
    private func setImageViewProperties(_ imageView: UIImageView, image: UIImage) {
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.tintColor = color
    }
    
}

//MARK: Date Extension
extension Date {
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension JSON {
    public var isNull: Bool {
        get {
            return self.type == .null;
        }
    }
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

//MARK: Make Label Copyable
class CopyableLabel: UILabel {
    
    override public var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(showMenu(sender:))
        ))
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    
    @objc func showMenu(sender: Any?) {
        becomeFirstResponder()
        _ = UIMenuController.shared
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(copy(_:)))
    }
}
