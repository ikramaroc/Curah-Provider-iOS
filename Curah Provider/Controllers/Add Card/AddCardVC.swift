//
//  AddCardVC.swift
//  QurahApp
//
//  Created by netset on 7/23/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class AddCardVC: BaseClass {
    @IBOutlet weak var textFldName: UCTextFld!
    @IBOutlet weak var textFldBankName: UCTextFld!
    @IBOutlet weak var textFldAccountNo: UCTextFld!
    @IBOutlet weak var textFldRoutingNo: UCTextFld!
    @IBOutlet weak var txtFldPhoneNo: UCTextFld!
    @IBOutlet weak var txtFldBankAddress: UCTextFld!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Bank Detail"
        self.underLineTextFldBottomLine(mainView: self.view, borderColor: UIColor.black)
        self.rightBarButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func rightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipAct))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name:Constants.AppFont.fontAvenirRoman, size:15)!], for: .normal)
    }
    
    @objc func skipAct() {
        let objAppDelegate = UIApplication.shared.delegate as! AppDelegate
        objAppDelegate.makingRoot("enterApp")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
      /*  let objAppDelegate = UIApplication.shared.delegate as! AppDelegate
        objAppDelegate.makingRoot("enterApp")*/
        self.Validations()
    }
    
    func Validations() {
        if (textFldName.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterYourName)
        } else if (textFldBankName.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterBankName)
        } else if (textFldAccountNo.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterAccountNumber)
        }else if (txtFldPhoneNo.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterPhoneNumber)
        }
        else if ((textFldAccountNo.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.count)! < 3 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterValidAccountNumber)
        } else if (textFldRoutingNo.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterRoutingNumber)
        }else if (txtFldBankAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterBankAddress)
        }
        else if ((textFldRoutingNo.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.count)! < 9 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterValidRoutingNumber)
        }  else {
            // Call API
            APIManager.sharedInstance.addBankDetailsAPI(bankName: (textFldBankName.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                                                        name: (textFldName.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                                                        accountNumber: (textFldAccountNo.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                                                        routingNumber: (textFldRoutingNo.text?.trimmingCharacters(in: .whitespacesAndNewlines))!, phone: "", postalCode: "") { (response) in
                                                            let actionSheetController = UIAlertController(title: Constants.App.name, message: response.message, preferredStyle: UIAlertControllerStyle.alert)
                                                            actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                                                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                                appDelegate.makingRoot("enterApp")
                                                            }))
                                                            self.present(actionSheetController, animated:true, completion:nil) //segueAddServices
            }
        }
    }
}
