//
//  EditDocumentVC.swift
//  CurahApp
//
//  Created by Netset on 27/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import AVFoundation

class EditDocumentVC: UIViewController {
    
    let imagePicker = UIImagePickerController()
    var photoTag = Int()
    @IBOutlet weak var imgViewDrivingLicence: UIImageView!
    @IBOutlet weak var imgViewIdentification: UIImageView!
    @IBOutlet weak var licenseNumberTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Document"
        initView()
        setUpData()
    }
    
    func  initView(){
        let leftbarBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(btnBack))
        navigationItem.leftBarButtonItem = leftbarBtn
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func setUpData(){
        
        let userData = ModalShareInstance.shareInstance.modalUserData.userInfo
        licenseNumberTxt.text = userData?.licenseNumber
        
        if userData?.license != nil{
        if (userData?.license?.count != 0) {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: (imgViewDrivingLicence.bounds.size.width)/2, y: (imgViewDrivingLicence.bounds.size.height)/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            self.imgViewDrivingLicence.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (userData?.imgUrl)! as String + (userData?.license!)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.imgViewDrivingLicence.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        }
        
        if userData?.identification_card != nil{
        if (userData?.identification_card?.count != 0) {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: (self.imgViewIdentification.bounds.size.width)/2, y: (self.imgViewIdentification.bounds.size.height)/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            self.imgViewIdentification.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (userData?.imgUrl)! as String + (userData?.identification_card!)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.imgViewIdentification.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
            }}
        
    }
    
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        if imgViewDrivingLicence.image == #imageLiteral(resourceName: "userPlaceholder") {
           Progress.instance.displayAlert(userMessage: Validation.call.uploadDrivingLicense)
        }
        else if imgViewIdentification.image == #imageLiteral(resourceName: "userPlaceholder") {
            Progress.instance.displayAlert(userMessage: Validation.call.uploadIdentificationCard)
        }
        else{
            updateDocuments()
        }
        
    }
    
    func updateDocuments(){
        
        APIManager.sharedInstance.updateDocuments(licenseImage: imgViewDrivingLicence.image!, idCardImage: imgViewIdentification.image!, licenseNumberStr: licenseNumberTxt.text!){ (response) in
            print(response)
            ModalShareInstance.shareInstance.modalUserData.userInfo?.license = response.documents?[0].driving_license
            ModalShareInstance.shareInstance.modalUserData.userInfo?.licenseNumber = response.documents?[0].license_number
            ModalShareInstance.shareInstance.modalUserData.userInfo?.identification_card = response.documents?[0].identification_card
            
            SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)
            
            Progress.instance.alertMessageWithActionOk(title: "Curah Provider", message: (response.message)!, action: {
                comeFromBank = true
                UserDefaults.standard.removeObject(forKey: "USERDETAILS")
                UserDefaults.standard.synchronize()
                ModalShareInstance.shareInstance.modalUserData = nil
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.makingRoot("initial")
            })
            
//            let actionSheetController = UIAlertController (title: "Curah Provider", message: (response.message)!, preferredStyle: UIAlertControllerStyle.alert)
//            actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
//            //Add Save-Action
//           self.navigationController?.popViewController(animated: true)
//
//            }))
//            self.present(actionSheetController, animated: true, completion: nil)
            
        }
    }
    
    @objc override func btnBack(){
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgViewDrivingLicence.layer.cornerRadius = imgViewDrivingLicence.frame.height / 2
        imgViewIdentification.layer.cornerRadius = imgViewIdentification.frame.height / 2
    }
    
    @IBAction func tapOnDrivingLicense(_ sender: Any) {
        photoTag = 1
        addPhoto()
    }
    
    @IBAction func tapOnIdentificationCardAct(_ sender: Any) {
        photoTag = 2
        addPhoto()
    }
    
    
    func addPhoto() {
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
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        present(alert, animated: true)
    }
    
}


extension EditDocumentVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage]  as? UIImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if photoTag == 1 {
            imgViewDrivingLicence.image = image
        } else {
            imgViewIdentification.image = image
        }
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
