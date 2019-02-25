//
//  CreateEditProfileVC.swift
//  CurahApp
//
//  Created by netset on 7/25/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import AVFoundation

class CreateProfileVC: BaseClass {
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var btnPickPhoto: UCButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textFldFirstName: UCTextFld!
    @IBOutlet weak var textFldLastName: UCTextFld!
    @IBOutlet weak var textFldMobileNo: UCTextFld!
    @IBOutlet weak var textFldYelpLink: UCTextFld!
    @IBOutlet weak var textFldInstaLink: UCTextFld!
    @IBOutlet weak var textFldFacebookLink: UCTextFld!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.underLineTextFldBottomLine(mainView: contentView, borderColor: UIColor.black)
        if ModalShareInstance.shareInstance.modalUserData != nil {
            let data = ModalShareInstance.shareInstance.modalUserData.userInfo
            textFldFirstName.text = data?.firstname
            textFldLastName.text = data?.lastname
            if data?.profileImageUrl != nil {
                DispatchQueue.global(qos: .background).async {
                    do {
                        let data = try? Data(contentsOf: (data?.profileImageUrl)!)
                        DispatchQueue.main.async {
                            if let imgData = data {
                                let image: UIImage = UIImage(data: imgData)!
                                self.btnPickPhoto.setBackgroundImage(image, for: .normal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarWithBackBtnAndTitle(title: "Create Profile")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPickPhoto(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.showOptions()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.showOptions()
                    //access allowed
                } else {
                    //access denied
                    self.alertPromptToAllowCameraAccessViaSetting()
                }
            })
        }
    }
    
    func showOptions() {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: "Error", message: "Access required to capture photo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { (alert) -> Void in
            (URL(string: UIApplicationOpenSettingsURLString)!)
        })
        present(alert, animated: true)
    }
    
    
    @IBAction func btnNextAct(_ sender: Any) {
        self.Validations()
    }
    
    func Validations()  {
        if textFldFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.firstName)
        } else if textFldMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.phone)
        }
            //        else if textFldFacebookLink.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            //            Progress.instance.displayAlert(userMessage: Validation.call.facebook)
            //        }
        else if (textFldFacebookLink.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 && !validateFbUrl(text: textFldFacebookLink.text!){
            Progress.instance.displayAlert(userMessage: Validation.call.facebookValid)
        }
            //        else if textFldInstaLink.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            //            Progress.instance.displayAlert(userMessage: Validation.call.insta)
            //        }
        else if (textFldInstaLink.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 && !validateInstaUrl(text: textFldInstaLink.text!){
            Progress.instance.displayAlert(userMessage: Validation.call.instaValid)
        } else {
            self.setUpData()
            self.performSegue(withIdentifier: segueId.createProfileToCompleteProfile.rawValue, sender: nil)
        }
    }
    func validateFbUrl(text:String) -> Bool{
        if text.validateUrl(){
            return true
        }
        return false
    }
    
    func validateInstaUrl(text:String) -> Bool{
        if text.validateUrl(){
            return true
        }
        return false
    }
    
    func setUpData() {
        var data = ModalShareInstance.shareInstance.modalUserData?.userInfo
        data?.firstname = textFldFirstName.text
        data?.lastname = textFldLastName.text
        data?.mobile = textFldMobileNo.text!
        data?.fbLink = textFldFacebookLink.text
        data?.instaLink = textFldInstaLink.text
        data?.yelpLink = textFldYelpLink.text
        data?.userImage = btnPickPhoto.backgroundImage(for: .normal)
        ModalShareInstance.shareInstance.modalUserData?.userInfo = data
    }
}

extension CreateProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         let image = info[UIImagePickerControllerEditedImage]  as? UIImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage
        btnPickPhoto.setBackgroundImage(image, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
    
    //MARK:-  Open Camera
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            openGallery()
        }
    }
    
    //MARK:-  Open Gallery
    func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension CreateProfileVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint.zero
        }
    }
}

extension CreateProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
            return false
        }
        
        
        return true
    }
}

