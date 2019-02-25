//
//  EditProfileVC.swift
//  Curah Provider
//
//  Created by Netset on 31/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import AVFoundation
import GoogleMaps

class EditProfileVC: BaseClass {
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var btnPickPhoto: UCButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var txtTo: UCTextFld!
    @IBOutlet weak var txtFrom: UCTextFld!
    @IBOutlet weak var txtLocation: UCTextFld!
    @IBOutlet weak var textFldFirstName: UCTextFld!
    @IBOutlet weak var textFldLastName: UCTextFld!
    @IBOutlet weak var textFldMobileNo: UCTextFld!
    @IBOutlet weak var textFldFacebookLink: UCTextFld!
    @IBOutlet weak var textFldInstaLink: UCTextFld!
    @IBOutlet weak var txtFldYelp: UCTextFld!
    @IBOutlet weak var textFldCity: UCTextFld!
    @IBOutlet weak var textFldExperience: UCTextFld!
    @IBOutlet weak var breakTimeTo: UCTextFld!
    @IBOutlet weak var breakTimeFrom: UCTextFld!
    
    
    let datePicker = UIDatePicker()
    var pickerView = UIPickerView()
    var locationCoordinate = CLLocationCoordinate2D()
    let experienceData  = [ "Less than a year", "1 year","2 years","3 years","4 years","5 years","6 years","7 years","8 years","9 years","10 years", "More than 10 years"]
    
    
    
    let citiesData = ["New York","Los Angeles","Chicago","Houston","Phoenix","Philadelphia","San Antonio","San Diego","Dallas","San Jose", "Austin","Jacksonville", "San Francisco","Columbus","Fort Worth","Indianapolis","Charlotte","Seattle","Denver","Washington","Boston","El Paso","Detroit","Nashville","Memph"
    ]
    
    var cityName = String()
    var stateName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.underLineTextFldBottomLine(mainView: contentView, borderColor: UIColor.black)
        // super.setupBackBtn(tintClr: .white)
        datePicker.datePickerMode = .time
        txtFrom.inputView = datePicker
        txtTo.inputView = datePicker
        
        //        breakTimeFrom.inputView = datePicker
        //        breakTimeTo.inputView = datePicker
        
        breakTimeFrom.inputView = datePicker
        breakTimeTo.inputView = datePicker
        
        
        datePicker.addTarget(self, action: #selector(selectDate(sender:)), for: .valueChanged)
        setUpData()
        /* let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(btnCancel))
         
         navigationItem.rightBarButtonItem = cancelBtn
         navigationItem.rightBarButtonItem?.tintColor = .white*/
        
    }
    
    func setUpData() {
        pickerView.delegate = self
        pickerView.dataSource = self
        // textFldCity.inputView = pickerView
        textFldExperience.inputView = pickerView
        let userData = ModalShareInstance.shareInstance.modalUserData.userInfo
        
        textFldFirstName.text = userData?.firstname
        textFldLastName.text = userData?.lastname
        textFldMobileNo.text = userData?.phone
        textFldFacebookLink.text = userData?.fbLink
        textFldInstaLink.text = userData?.instaLink
        textFldExperience.text = userData?.experience
        txtLocation.text = userData?.address
        textFldCity.text = userData?.city
        locationCoordinate.latitude = Double(userData!.latitude!) ?? 0.0
        locationCoordinate.longitude = Double(userData!.longitude!) ?? 0.0
        txtTo.text = conversion12hrFormatTo24hrFormat(dateStr:(userData?.appointment_to) ?? "")
        txtFrom.text = conversion12hrFormatTo24hrFormat(dateStr:(userData?.appointment_from) ?? "")
        breakTimeFrom.text = conversion12hrFormatTo24hrFormat(dateStr:(userData?.breakHrsFrom) ?? "")
        breakTimeTo.text = conversion12hrFormatTo24hrFormat(dateStr:(userData?.breakHrsTo) ?? "")
        
        if (userData?.profileImage?.count != 0) {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: (btnPickPhoto.bounds.size.width)/2, y: (btnPickPhoto.bounds.size.height)/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            btnPickPhoto.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (userData?.imgUrl)! as String + (userData?.profileImage!)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.btnPickPhoto.setImage(image, for: .normal)
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarWithBackBtnAndTitle(title: "Edit Profile")
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /* @objc func btnCancel(){
     navigationController?.popViewController(animated: true)
     }*/
    
    @IBAction func enterLocationAct(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "USA"
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func selectDate(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "hh:mm a"
        
        if txtTo.isFirstResponder {
            txtTo.text =  super.conversion12hrFormatTo24hrFormat(dateStr:dateFormatter.string(from: datePicker.date))
        }
        if txtFrom.isFirstResponder{
            txtFrom.text = super.conversion12hrFormatTo24hrFormat(dateStr:dateFormatter.string(from: datePicker.date))
        }
        if breakTimeFrom.isFirstResponder {
            breakTimeFrom.text =  super.conversion12hrFormatTo24hrFormat(dateStr:dateFormatter.string(from: datePicker.date))
        }
        if breakTimeTo.isFirstResponder{
            breakTimeTo.text = super.conversion12hrFormatTo24hrFormat(dateStr:dateFormatter.string(from: datePicker.date))
        }
    }
    
    @IBAction func updateProfileBtnAction(_ sender: UIButton) {
//        if btnPickPhoto.backgroundImage(for: .normal) == #imageLiteral(resourceName: "profile") {
//            Progress.instance.displayAlert(userMessage: Validation.call.profilePhoto)
//        }  else
        
            if textFldFirstName.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.firstName)
        } else if textFldLastName.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.lastName)
        } else if textFldMobileNo.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.phone)
        }
            //        else if textFldFacebookLink.text?.count == 0 {
            //            Progress.instance.displayAlert(userMessage: Validation.call.facebook)
            //        }else if textFldInstaLink.text?.count == 0 {
            //            Progress.instance.displayAlert(userMessage: Validation.call.insta)
            //        }
        else if (textFldFacebookLink.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 && !validateFbUrl(text: textFldFacebookLink.text!){
            Progress.instance.displayAlert(userMessage: Validation.call.facebookValid)
        } else if (textFldInstaLink.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 && !validateInstaUrl(text: textFldInstaLink.text!){
            Progress.instance.displayAlert(userMessage: Validation.call.instaValid)
        } else if textFldExperience.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterExperience)
        } else if txtLocation.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterLocation)
        } else if textFldCity.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterCity)
        } else if txtTo.text?.count == 0 || txtFrom.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.workingHrs)
        }else if breakTimeFrom.text?.count == 0 || breakTimeTo.text?.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.breakHrs)
        }else {
            saveSetUpData()
            editProfile(startDate: super.conversion12hrFormatTo24hrFormat(dateStr: txtTo.text!) ,endDate: super.conversion12hrFormatTo24hrFormat(dateStr: txtFrom.text!), city: cityName, breakStartStr: super.conversion12hrFormatTo24hrFormat(dateStr: breakTimeFrom.text!), breakEndStr: super.conversion12hrFormatTo24hrFormat(dateStr: breakTimeTo.text!), state: stateName, location: locationCoordinate)
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
    
    func saveSetUpData() {
        var data = ModalShareInstance.shareInstance.modalUserData?.userInfo
        data?.userImage = btnPickPhoto.currentImage
        data?.firstname = textFldFirstName.text
        data?.lastname = textFldLastName.text
        data?.mobile = textFldMobileNo.text
        data?.fbLink = textFldFacebookLink.text
        data?.instaLink = textFldInstaLink.text
        data?.yelpLink = txtFldYelp.text
        data?.experience = textFldExperience.text
        data?.location = txtLocation.text
        data?.city = textFldCity.text
        data?.workingHrsTo =  txtTo.text!
        data?.workingHrsFrom = txtFrom.text!
        data?.breakHrsFrom = breakTimeFrom.text!
        data?.breakHrsTo = breakTimeTo.text!
        ModalShareInstance.shareInstance.modalUserData?.userInfo = data
    }
    
    func editProfile(startDate:String,endDate:String,city:String,breakStartStr:String,breakEndStr:String ,state:String,location:CLLocationCoordinate2D){
        
        if cityName.count == 0{
            cityName = ModalShareInstance.shareInstance.modalUserData.userInfo?.city ?? ""
        }
        if stateName.count == 0{
            stateName = ModalShareInstance.shareInstance.modalUserData.userInfo?.state ?? ""
        }
        
        APIManager.sharedInstance.editProfileAPI(startTime:startDate,endTime:endDate, breakStart: breakStartStr, breakEnd: breakEndStr,location: locationCoordinate, cityStr:cityName,stateStr:stateName) { (response) in
            print(response)
            ModalShareInstance.shareInstance.modalUserData = response
            SaveUserResponse.sharedInstance.saveToSharedPrefs(user: response)
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
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
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        present(alert, animated: true)
    }
}

extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        //        txtLocation.text = place.formattedAddress
        //        textFldCity.text = place.name
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
                self.textFldCity.text = cityNameStr
                
                self.cityName = address.locality ?? ""
                self.stateName = address.administrativeArea ?? ""
                APIManager().hideHud()
            }
            
        }
        
    }
    
    
    //    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, locationName: String,cityName:String)  {
    //        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
    //        let lat: Double = Double("\(pdblLatitude)")!
    //        //21.228124
    //        let lon: Double = Double("\(pdblLongitude)")!
    //        //72.833770
    //        let ceo: CLGeocoder = CLGeocoder()
    //        center.latitude = lat
    //        center.longitude = lon
    //
    //        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
    //
    //        ceo.reverseGeocodeLocation(loc, completionHandler:
    //            {(placemarks, error) in
    //                if (error != nil)
    //                {
    //                    print("reverse geodcode fail: \(error!.localizedDescription)")
    //                }
    //                let pm = placemarks! as [CLPlacemark]
    //
    //                if pm.count > 0 {
    //                    let pm = placemarks![0]
    //                    print(pm.country)
    //                    print(pm.locality)
    //                    print(pm.subLocality)
    //                    print(pm.thoroughfare)
    //                    print(pm.postalCode)
    //                    print(pm.subThoroughfare)
    //
    //                    if let stateName = pm.locality{
    //
    //                        if stateName.contains("San Francisco"){
    //                            self.txtLocation.text = locationName
    //                            self.textFldCity.text = cityName
    //
    //                        }else{
    //                            Progress.instance.displayAlertWindow(userMessage: "We are not working here , please choose from San Franscisco or Bay Area")
    //                        }
    //                    }
    //                }
    //        })
    //
    //    }
    
    
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

extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerEditedImage]  as? UIImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage
        
        btnPickPhoto.setImage(pickedImage, for: .normal)
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
        }else {
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

extension EditProfileVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    }
}

extension EditProfileVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint.zero
        }
    }
}



