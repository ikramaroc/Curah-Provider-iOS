//
//  ForgotPassswordViewController.swift
//  QurahApp
//
//  Created by netset on 7/13/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class ForgotPassswordViewController: BaseClass {

    @IBOutlet weak var textFldEmailAddress: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupBackBtn(tintClr: .white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validations() {
        self.view.endEditing(true)
        if textFldEmailAddress.text?.count==0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterEmail)
        } else if !checkEmailValidation(textFldEmailAddress.text!) {
            Progress.instance.displayAlert(userMessage: Validation.call.validEmail)
        }  else {
            self.forgotPasswordAPI()
        }
    }
    
    func forgotPasswordAPI() {
        APIManager.sharedInstance.forgotPasswordAPI(email: textFldEmailAddress.text!) { (response) in
            self.performSegue(withIdentifier: "forgotPopUp", sender: nil)
        }
    }
    
}

//MARK:- All ACTIONS HERE
extension ForgotPassswordViewController {
    
    @IBAction func submitAction(_ sender: Any) {
          self.validations()
    }
}


extension ForgotPassswordViewController: UITextFieldDelegate {
    
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
        return true
    }
}


