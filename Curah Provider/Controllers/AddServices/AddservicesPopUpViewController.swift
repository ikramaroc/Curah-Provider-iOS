//
//  AddservicesPopUpViewController.swift
//  Curah Provider
//
//  Created by Netset on 21/09/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

protocol passAddServicesDataProtocol {
    func refreshData()
}


class AddservicesPopUpViewController: BaseClass {
    var suggestedServices : [Services]!
    fileprivate var isEdited : Bool = false
    var selectedSuggestedServices : [Services]!
    var userServices : [Services]!
    var selectedIndex : Int = -1
    
    fileprivate var savedServices : [ServicesData] = []
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textFldPrice: UCTextFld!
    @IBOutlet weak var textFldServiceName: UCTextFld!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var delegate:passAddServicesDataProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Services"
        self.navigationItem.hidesBackButton=true
        self.initView()
        
        self.selectedSuggestedServices = self.suggestedServices
        self.collectionView.reloadData()
        
        if isEditing{
            let services = ModalShareInstance.shareInstance.modalUserData.services![selectedIndex]
            textFldPrice.text = "\(services.price!)"
            textFldServiceName.text = services.name!
            textFldServiceName.isUserInteractionEnabled = false
        }else{
            textFldServiceName.isUserInteractionEnabled = true
        }
        
        
        self.fetchSuggestedServicesAPI()
    }
    func initView(){
        /* for txt in txtFields {
         txt.setBottomBorder(color: .white)
         } */
        //  super.underLineTextFldBottomLine(mainView: self.view)
        super.underLineTextFldBottomLine(mainView: self.contentView, borderColor: UIColor.white)
        
    }
    
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //MARK:- Suggested Services API *******
    func fetchSuggestedServicesAPI() {
        APIManager.sharedInstance.getSuggestedServicesAPI() { (response) in
            self.suggestedServices = response.services
            self.selectedSuggestedServices = self.suggestedServices
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func btnSubmitAct(_ sender: Any) {
        if textFldServiceName.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage: "Please enter service name")
        } else if textFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage: "Please enter service price")
        } else if textFldPrice.text == "0" {
            Progress.instance.displayAlert(userMessage: "Please enter valid service price")
        } else {
            if selectedIndex >= 0 {
                if textFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                    Progress.instance.displayAlert(userMessage: "Please enter service price")
                } else {
                    if isEditing {
                        let service = self.userServices[selectedIndex]
                        let obj = ServicesData(name: service.name, serviceId: "\(String(describing: service.serviceId))", price: Int((textFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines))!))
                        //                        self.savedServices.remove(at: selectedIndex)
                        //                        self.savedServices.append(obj)
                        self.collectionView.reloadData()
                        APIManager.sharedInstance.updateServicesAPI(serviceId: service.serviceId!, price: textFldPrice.text!){ (response) in
                            if response.status == 200 {
                                ModalShareInstance.shareInstance.modalUserData.services = response.services
                                self.delegate.refreshData()
                                
                                SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)
                                let actionSheetController = UIAlertController(title: Constants.App.name, message: response.message, preferredStyle: UIAlertControllerStyle.alert)
                                actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                                    self.performSegue(withIdentifier: segueId.addBankDetail.rawValue, sender: nil)
                                }))
                                self.present(actionSheetController, animated:true, completion:nil)
                            }
                        }
                        
                    } else {
                        let service = self.selectedSuggestedServices[selectedIndex]
                        let obj = ServicesData(name: service.name, serviceId: "\(service.serviceId ?? 0)", price: Int((textFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines))!))
                        self.savedServices.append(obj)
                        APIManager.sharedInstance.addServicesAPI(servicesData: savedServices, custom:true)
                        { (response) in
                            if response.status == 200 {
                                ModalShareInstance.shareInstance.modalUserData.services = response.services
                                self.delegate.refreshData()
                                
                                SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)
                                let actionSheetController = UIAlertController(title: Constants.App.name, message: response.message, preferredStyle: UIAlertControllerStyle.alert)
                                actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                                    self.performSegue(withIdentifier: segueId.addBankDetail.rawValue, sender: nil)
                                }))
                                self.present(actionSheetController, animated:true, completion:nil)
                            }
                        }
                        
                        self.savedServices.append(obj)
                        // self.selectedSuggestedServices.remove(at: selectedIndex)
                        self.collectionView.reloadData()
                        
                    }
                }
            } else {
                let obj = ServicesData(name: textFldServiceName.text?.trimmingCharacters(in: .whitespacesAndNewlines), serviceId: "C", price: Int((textFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines))!))
                self.savedServices.append(obj)
                self.collectionView.reloadData()
                
                APIManager.sharedInstance.addServicesAPI(servicesData: savedServices, custom:false)
                { (response) in
                    if response.status == 200 {
                        ModalShareInstance.shareInstance.modalUserData.services = response.services
                        SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)
                        
                        self.delegate.refreshData()
                        
                        SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)
                        let actionSheetController = UIAlertController(title: Constants.App.name, message: response.message, preferredStyle: UIAlertControllerStyle.alert)
                        actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                            self.performSegue(withIdentifier: segueId.addBankDetail.rawValue, sender: nil)
                        }))
                        self.present(actionSheetController, animated:true, completion:nil)
                    }
                }
                
                self.setData()
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func setData() {
        self.isEdited=false
        self.textFldServiceName.isEnabled=true
        self.textFldServiceName.text = ""
        
        self.collectionView.reloadData()
        self.textFldPrice.text = ""
        self.selectedIndex = -1
        delegate.refreshData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension AddservicesPopUpViewController :UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.selectedSuggestedServices != nil else {
            return 0
        }
        return self.selectedSuggestedServices.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddServicesCell
        cell.lblTitle.text = self.selectedSuggestedServices?[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        textFldServiceName.text = self.selectedSuggestedServices?[selectedIndex].name
        textFldServiceName.isEnabled = false
        textFldPrice.text = "\(self.selectedSuggestedServices?[selectedIndex].price ?? 0)"
        isEdited = false
        // selectedSuggestedServices.remove(at: indexPath.row)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize = (self.selectedSuggestedServices?[indexPath.item].name!)!.size(withAttributes: [NSAttributedStringKey.font: UIFont(name: Constants.AppFont.fontAvenirBook, size: 12.0)!])
        return CGSize(width: size.width + 45.0, height: collectionView.frame.size.height)
    }
}
extension AddservicesPopUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFldPrice{
            if textField.text!.first == "0"{
                textField.text = ""
            }
        }
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
        /*if textField==textFldPrice {
         if string.hasPrefix("0") {
         return false
         }
         }*/
        return true
    }
}


