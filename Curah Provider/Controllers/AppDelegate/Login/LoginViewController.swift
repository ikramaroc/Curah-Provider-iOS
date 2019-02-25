//
//  LoginViewController.swift
//  CurahApp
//
//  Created by netset on 7/13/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import Crashlytics

class LoginViewController: BaseClass {
    
    @IBOutlet weak var textFldEmailAddress: UITextField!
    @IBOutlet weak var textFldPassword: UITextField!
    @IBOutlet weak var accountApproveView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        
        
//        textFldEmailAddress.text = "gss@yopmail.com"
//        textFldPassword.text = "12345678"
        
       
        
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
         transparentNavigationBar()

        if comeFromBank{
            accountApproveView.isHidden = false
        }
        comeFromBank = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if accountApproveView.isHidden == true{
        }else{
            accountApproveView.isHidden = true
        }
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        if accountApproveView.isHidden == true{
        }else{
            accountApproveView.isHidden = true
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Validations() {
        
//        Crashlytics.sharedInstance().crash()
        
        self.view.endEditing(true)
        if textFldEmailAddress.text?.count==0 {
            Progress.instance.displayAlert(userMessage:Validation.call.enterEmail)
        } else if !checkEmailValidation(textFldEmailAddress.text!) {
            Progress.instance.displayAlert(userMessage:Validation.call.validEmail)
        } else if textFldPassword.text?.count==0 {
            Progress.instance.displayAlert(userMessage:Validation.call.enterPassword)
        } else {
            self.loginAPI()
        }
    }
    
    //MARK:- Login API *******
    
    func loginAPI() {
        APIManager.sharedInstance.loginAPI(email: textFldEmailAddress.text!, password: textFldPassword.text!,token:getDeviceToken()) { (response) in
            if response.status! == 406 {
                self.accountApproveView.isHidden = false
            } else if response.status! == 404 {
                 Progress.instance.displayAlert(userMessage:response.message!)
            } else if response.status! == 200{
                ModalShareInstance.shareInstance.modalUserData = response
                isSocialLogin = false
                if response.userInfo?.firstname == nil || response.userInfo?.firstname?.count == 0 {
                    self.performSegue(withIdentifier: segueId.loginToCreateProfile.rawValue, sender: nil)
                } else if response.services?.count == 0 {
                    self.performSegue(withIdentifier: segueId.completeProfileToAddServices.rawValue, sender: nil)
                } else {
                    SaveUserResponse.sharedInstance.saveToSharedPrefs(user: response)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.makingRoot("enterApp")
                }
            }
                
                
            
//                else if response.status! == 404 {
//                self.accountApproveView.isHidden = false
//
//              //  Progress.instance.displayAlert(userMessage: response.message!)
//            }//segueAddServices
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.Validations()
     }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
            return false
        }
        if (textField.text?.count)! == 0 && string == " " {
            return false
        }
        if textField==textFldPassword {
            if string == " " {
                return false
            }
        }
        return true
    }
}

