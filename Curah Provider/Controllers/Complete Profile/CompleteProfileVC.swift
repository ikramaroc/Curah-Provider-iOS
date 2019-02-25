//
//  CompleteProfileVC.swift
//  Curah Provider
//
//  Created by Netset on 31/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import AVFoundation

class CompleteProfileVC: BaseClass {
    
    @IBOutlet weak var btnPickPhoto: UCButton!
    @IBOutlet weak var btnPickIdenfication: UCButton!
    @IBOutlet weak var textFldExperience: UCTextFld!
    @IBOutlet weak var txtLocation: UCTextFld!
    @IBOutlet weak var textfldCity: UCTextFld!
    @IBOutlet weak var txtTo: UCTextFld!
    @IBOutlet weak var txtFrom: UCTextFld!
    @IBOutlet weak var breakFrom: UCTextFld!
    @IBOutlet weak var breakTo: UCTextFld!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var licenseNumberTxt: UCTextFld!
    
    var locationCoordinate = CLLocationCoordinate2D()
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    var pickerView = UIPickerView()
    var cityName = String()
    var stateName = String()
    var isPickingDrivingPic : Bool = true
    let experienceData  = [ "Less than a year", "1 year","2 years","3 years","4 years","5 years","6 years","7 years","8 years","9 years","10 years", "More than 10 years"]
    var data : UserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        textFldExperience.inputView = pickerView
        datePicker.datePickerMode = .time
        txtFrom.inputView = datePicker
        txtTo.inputView = datePicker
        breakTo.inputView = datePicker
        breakFrom.inputView = datePicker
        datePicker.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
        data = ModalShareInstance.shareInstance.modalUserData.userInfo
        self.setUpInitially()
        super.underLineTextFldBottomLine(mainView: contentView, borderColor: UIColor.black)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarWithBackBtnAndTitle(title: "Complete Profile")
         currentScreenStr = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func selectDate(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "hh:mm a"
        if txtTo.isFirstResponder {
            txtTo.text = dateFormatter.string(from: datePicker.date)
        }
        if txtFrom.isFirstResponder {
            txtFrom.text = dateFormatter.string(from: datePicker.date)
        }
        if breakFrom.isFirstResponder {
            breakFrom.text = dateFormatter.string(from: datePicker.date)
        }
        if breakTo.isFirstResponder {
            breakTo.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @IBAction func enterLocationAct(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "USA"
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction func btnCreateProfile(_ sender: UIButton) {
        self.Validations()
    }
    
    @IBAction func btnPickIdentification(_ sender: UCButton) {
        isPickingDrivingPic = false
        pickImage()
    }
    
    @IBAction func btnPickPhoto(_ sender: Any) {
        isPickingDrivingPic = true
        pickImage()
    }
    
    func pickImage(){
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
    
    
    func Validations()  {
        if btnPickPhoto.currentImage == nil {
            Progress.instance.displayAlert(userMessage: Validation.call.uploadDrivingLicense)
        } else if btnPickIdenfication.currentImage == nil {
            Progress.instance.displayAlert(userMessage: Validation.call.uploadIdentificationCard)
        } else if textFldExperience.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterExperience)
        } else if txtLocation.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterLocation)
        } else if textfldCity.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterCity)
        } else if txtTo.text?.count == 0 || txtFrom.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.workingHrs)
        }else if breakTo.text?.count == 0 || breakFrom.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.breakHrs)
        } else if btnPickPhoto.currentImage == #imageLiteral(resourceName: "profile") {
            Progress.instance.displayAlert(userMessage: Validation.call.noPhotoDR)
        }else if btnPickIdenfication.currentImage == #imageLiteral(resourceName: "profile")  {
            Progress.instance.displayAlert(userMessage: Validation.call.noPhotoID)
        }else {
            self.setUpData()
            self.createProfileAPI()
        }
    }
    
    func setUpData() {
        var data = ModalShareInstance.shareInstance.modalUserData?.userInfo
        data?.drivingLicenseImage = btnPickPhoto.currentImage!
        data?.licenseNumber = licenseNumberTxt.text
        data?.identificationCardImage = btnPickIdenfication.currentImage!
        data?.experience = textFldExperience.text
        data?.location = txtLocation.text
        data?.city = textfldCity.text
        data?.workingHrsTo = txtTo.text
        data?.workingHrsFrom = txtFrom.text
        data?.breakHrsFrom = breakFrom.text
        data?.breakHrsTo = breakTo.text
        
        ModalShareInstance.shareInstance.modalUserData?.userInfo = data
    }
    
    func setUpInitially() {
        btnPickPhoto.setImage(data?.drivingLicenseImage, for: .normal)
        btnPickIdenfication.setImage(data?.identificationCardImage, for: .normal)

        textFldExperience.text = data?.experience
        txtLocation.text = data?.location
        textfldCity.text = data?.city
        txtTo.text =  data?.workingHrsTo
        txtFrom.text = data?.workingHrsFrom
        
    }
    
    func createProfileAPI() {
        APIManager.sharedInstance.createProfileAPI(location: locationCoordinate,cityStr:cityName,stateStr:stateName) { (response) in
            print(response)
           ModalShareInstance.shareInstance.modalUserData = response
           self.performSegue(withIdentifier: segueId.completeProfileToAddServices.rawValue, sender: nil)
        }
    }
}

extension CompleteProfileVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
//        txtLocation.text = place.formattedAddress
//        textfldCity.text = place.name
        locationCoordinate = place.coordinate
        dismiss(animated: true, completion: nil)
        
        getAddressFromLatLon(pdblLatitude: "\(place.coordinate.latitude)", withLongitude: "\(place.coordinate.longitude)", locationName:place.formattedAddress!, cityNameStr: place.name )
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, locationName: String,cityNameStr:String){
        
        APIManager().showHud()
        
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(lat),Double(lon))
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                

                
                self.txtLocation.text = locationName
                self.textfldCity.text = cityNameStr
                
                self.cityName = address.locality ?? ""
                self.stateName = address.administrativeArea ?? ""
                APIManager().hideHud()
            }
            
        }
        
    }
    
   
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension CompleteProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage]  as? UIImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if isPickingDrivingPic {
            btnPickPhoto.setImage(image, for: .normal)
        } else {
            btnPickIdenfication.setImage(image, for: .normal)
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

extension CompleteProfileVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return experienceData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return experienceData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFldExperience.text = experienceData[row]
        data?.experience = experienceData[row]
    }
}
