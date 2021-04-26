//
//  OnBoardingViewController.swift
//  MadeLive
//
//  Created by Mobile Dev on 30/01/20.
//  Copyright © 2020 Mobile Dev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

//MARK: Onboarding Slider Collection Cell
class SliderCollectionCell: UICollectionViewCell {
    @IBOutlet var lblSteps: UILabel!
    @IBOutlet var lblStepsText: UILabel!
    @IBOutlet var sliderImage: UIImageView!
    @IBOutlet var viewTopGestureLayer: UIView!
    @IBOutlet var txtEmail: UITextField!
}

class OnBoardingViewController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {
    
    //Local Declarations & Vars
    @IBOutlet var sliderCollection: UICollectionView!
    @IBOutlet var pagerConrol: UIPageControl!
    @IBOutlet var btnNext: UIButton!
    
    var selectedIndex = 0
    var titleArray = ["Welcome Slider 1","Welcome Slider 2","Welcome Slider 3","Register with Us"]
    var textArray = ["Details for welcome slider 1","Details for welcome slider 2","Details for welcome slider 3",""]
    var lastContentOffset: CGFloat = 0.0
    var userEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Skip button click
    @IBAction func skipClick(sender: UIButton) {
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
        self.navigationController?.pushViewController(tabVC, animated: true)
    }
    
    //MARK:- Next button click
    @IBAction func nextClick(sender: UIButton) {
        if self.selectedIndex < 3 {
            self.selectedIndex = self.selectedIndex + 1
            self.sliderCollection.selectItem(at: IndexPath(item: self.selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            self.pagerConrol.currentPage = self.selectedIndex
        } else {
            self.view.endEditing(true)
            self.registerNow()
        }
    }
    
    //MARK: Textfield delegate methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.userEmail = textField.text!
    }
    
    //MARK: Register Click
    func registerNow() {
        if self.userEmail != ""{
            self.makeLogin()
        } else {
            //Remove Stored Key if available
            UserDefaults.standard.removeObject(forKey: "UserEmail")
            UserDefaults.standard.removeObject(forKey: "UUID")
            UserDefaults.standard.synchronize()
            let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
            self.navigationController?.pushViewController(tabVC, animated: true)
        }
    }
    
    //MARK: - Make User Login Method
    func makeLogin(){
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let identifier = UUID()
        let uuid = identifier.uuidString
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(self.userEmail, forKey: "email")
        param.setValue(uuid, forKey: "uuid")
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            
            let dataObj : JSON = JSON.init(responseObject)
            if !dataObj.isNull {
                if(dataObj["response"].boolValue == true) {
                    //Save User Data
                    UserDefaults.standard.set(self.userEmail, forKey: "UserEmail")
                    UserDefaults.standard.set(uuid, forKey: "UUID")
                    UserDefaults.standard.synchronize()
                    let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
                    self.navigationController?.pushViewController(tabVC, animated: true)
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
        }
        service.PostWithAlamofire(Parameters: param as? [String : AnyObject], action: REGISTERAPI as NSString, success: successed, failure: failure)
    }
}

//MARK:- Slider Collection Delegate and Datasource Methods
extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.sliderCollection.dequeueReusableCell(withReuseIdentifier: "SliderCollectionCell", for: indexPath) as! SliderCollectionCell
        cell.lblSteps.text = self.titleArray[indexPath.row].capitalized
        cell.sliderImage.image = UIImage.init(named: "get_in_started")
        cell.lblStepsText.text = self.textArray[indexPath.row]
        cell.txtEmail.isHidden = true
        cell.lblStepsText.isHighlighted = false
        if indexPath.row == 3 {
            cell.txtEmail.delegate = self
            cell.txtEmail.isHidden = false
            cell.lblStepsText.isHighlighted = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.sliderCollection.frame.width , height: self.sliderCollection.frame.height)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.x > 0 {
            // swipes from left to right
            if self.selectedIndex == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            // swipes from Right to left
            if self.selectedIndex == 3 {
                self.view.endEditing(true)
                self.registerNow()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = self.sliderCollection.indexPathForItem(at: center) {
            self.selectedIndex = ip.row
            self.pagerConrol.currentPage = ip.row
        }
    }
}
