//
//  AddPortfiloVC.swift
//  CurahApp
//
//  Created by Netset on 27/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import AVFoundation
import KMPlaceholderTextView

protocol reloadDataAfterUpdationProtocol {
    func reloadListData()
}

class AddPortfiloVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var descriptionTxt: KMPlaceholderTextView!
    @IBOutlet weak var addImageBtn: UIButton!
    
    @IBOutlet weak var navigationTitleLbl: UILabel!
    let imagePicker = UIImagePickerController()
    var videoUrl = URL(fileURLWithPath: "")
    var delegate1 : reloadDataAfterUpdationProtocol!
    var selectedImage = UIImage()
    var type = String()
    var isEditingPortfolio = false
    
    //for editing
    var titleStr = String()
    var descriptionStr = String()
    var dataType = String()
    var thumbUrl = String()
    var portfolioId =  Int()
    var userSelection = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditingPortfolio
        {
            setUpDataForEditing()
        }
        
        
    }
    
    func setUpDataForEditing()
    {
        self.navigationTitleLbl.text = "Edit Portfolio"
        self.titleTxt.text = titleStr
        self.descriptionTxt.text = descriptionStr
        
        if (thumbUrl.count != 0) {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: (imgView.bounds.size.width)/2, y: (imgView.bounds.size.height)/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            imgView.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: thumbUrl, completionHandler:{(image: UIImage?, url: String) in
                self.imgView.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        if dataType != "image"
        {
            addImageBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCloseAct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        imgView.layer.cornerRadius = imgView.frame.height / 2
    }
    
    @IBAction func btnSubmint(_ sender: UIButton) {
        
        
        if titleTxt.text?.count==0 {
            Progress.instance.displayAlert(userMessage:Validation.call.enterTitle)
        }
        else if descriptionTxt.text?.count==0 {
            Progress.instance.displayAlert(userMessage:Validation.call.enterDescription)
        }
        else if type.count==0  && !isEditingPortfolio {
            Progress.instance.displayAlert(userMessage:Validation.call.enterType)
        }
        else
        {
            if isEditingPortfolio
            {
                if userSelection
                {
                    if type == "image"
                    {
                        editPortfolio(image: selectedImage, videoUrl: videoUrl, type: type, title: titleTxt.text!, description: descriptionTxt.text!, video_thumb: UIImage() )
                    }
                    else
                    {
                        editPortfolio(image: selectedImage, videoUrl: videoUrl, type: type, title: titleTxt.text!, description: descriptionTxt.text!, video_thumb:getThumbnailImage(forUrl: videoUrl)! )
                    }
                }
                else
                {
                     editPortfolio(image: selectedImage, videoUrl: videoUrl, type: type, title: titleTxt.text!, description: descriptionTxt.text!, video_thumb:UIImage() )
                }
            }
            else
            {
                if type == "image"
                {
                    addPortfolio(image: selectedImage, videoUrl: videoUrl, type: type, title: titleTxt.text!, description: descriptionTxt.text!, video_thumb: UIImage() )
                }
                else
                {
                    addPortfolio(image: selectedImage, videoUrl: videoUrl, type: type, title: titleTxt.text!, description: descriptionTxt.text!, video_thumb:getThumbnailImage(forUrl: videoUrl)! )
                }
            }
        }
        
    }
    
    @IBAction func addProfileBtnAction(_ sender: UIButton) {
        
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  .authorized {
            //already authorized
            self.showOptions()
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
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
    
    
    
    @IBAction func addProfilePhotoAct(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  .authorized {
            //already authorized
            self.showOptions()
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
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
    
    //MARK:- Add portfolio API *******
    func addPortfolio(image:UIImage,videoUrl:URL,type:String,title:String,description:String,video_thumb:UIImage)
    {
        APIManager.sharedInstance.addPortfolio(image: image,videoUrl: videoUrl, type: type, title: title, description: description, videoThumb:video_thumb, isEditing: false, portfolioId: 0){ (response) in
            
            let actionSheetController = UIAlertController (title: Constants.App.name, message: response.message!, preferredStyle: UIAlertControllerStyle.alert)
            actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(actionSheetController, animated:true, completion:nil)
            self.delegate1.reloadListData()
            
        }
    }
    
    //MARK:- Edit portfolio API *******
    func editPortfolio(image:UIImage,videoUrl:URL,type:String,title:String,description:String,video_thumb:UIImage)
    {
        if  userSelection
        {
            APIManager.sharedInstance.addPortfolio(image: image,videoUrl: videoUrl, type: type, title: title, description: description, videoThumb:video_thumb, isEditing: true, portfolioId: portfolioId){ (response) in
                
                let actionSheetController = UIAlertController (title: Constants.App.name, message: response.message!, preferredStyle: UIAlertControllerStyle.alert)
                actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(actionSheetController, animated:true, completion:nil)
                self.delegate1.reloadListData()
                
            }
        }
        else
        {
            APIManager.sharedInstance.updatePortfolio(type: type, title: title, description: description, portfolioId: portfolioId ){ (response) in
                
                let actionSheetController = UIAlertController (title: Constants.App.name, message: response.message!, preferredStyle: UIAlertControllerStyle.alert)
                actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(actionSheetController, animated:true, completion:nil)
//                self.delegate.reloadData()
                
            }
        }
    }
    
}

extension AddPortfiloVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as? String
        
        let image = info[UIImagePickerControllerEditedImage]  as? UIImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage
        
        userSelection = true
        
        if mediaType  == "public.image" {
            print("Image Selected")
            
            imgView.image = image
            
            videoUrl = URL(fileURLWithPath: "")
            selectedImage = image!
            type = "image"
            
        }
        
        if mediaType == "public.movie" {
            print("Video Selected")
            
            let pickedVideo = info[UIImagePickerControllerMediaURL] as? URL
            
            let videoData : Data!
            do {
                try! videoData = Data(contentsOf: pickedVideo as! URL)
                var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory = paths[0]
                let tempPath = documentsDirectory.appendingFormat("/vid1.mp4")
                let url = URL(fileURLWithPath: tempPath)
                do
                {
                    try! _ = videoData.write(to: url, options: [])
                }
                
                imgView.image = getThumbnailImage(forUrl: url)
                
                videoUrl = url
                type = "video"
                
            }
            
            ///
            
        }
        
        if type != "image"
        {
            addImageBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
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
             imagePicker.mediaTypes = ["public.image", "public.movie"]
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            openGallery()
        }
    }
    
    //MARK:-  Open Gallery
    func openGallery() {
        imagePicker.delegate = self
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        self.present(imagePicker, animated: true, completion: nil)
    }
}

