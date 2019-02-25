//
//  AddServicesVC.swift
//  Curah Provider
//
//  Created by Netset on 31/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

class AddServicesVC: BaseClass {
    
    fileprivate var suggestedServices : [Services]!
    fileprivate var isEdited : Bool = false
    fileprivate var selectedSuggestedServices : [Services]!
    fileprivate var selectedIndex : Int = -1
    fileprivate var savedServices : [ServicesData] = []
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textFldPrice: UCTextFld!
    @IBOutlet weak var textFldServiceName: UCTextFld!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 45
        self.title = "Add Services"
        self.navigationItem.hidesBackButton=true
        self.initView()
        self.fetchSuggestedServicesAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        /* for txt in txtFields {
         txt.setBottomBorder(color: .white)
         } */
        //  super.underLineTextFldBottomLine(mainView: self.view)
        super.underLineTextFldBottomLine(mainView: self.contentView, borderColor: UIColor.white)
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(btnDone))
        navigationItem.rightBarButtonItem = doneBtn
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func btnDone() {
        if savedServices.count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.minService)
        } else {
            APIManager.sharedInstance.addServicesAPI(servicesData: savedServices, custom: false) { (response) in
                if response.status == 200 {
                    ModalShareInstance.shareInstance.modalUserData.services = response.services
                    SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)
                    let actionSheetController = UIAlertController(title: Constants.App.name, message: response.message, preferredStyle: UIAlertControllerStyle.alert)
                    actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                        self.performSegue(withIdentifier: segueId.addBankDetail.rawValue, sender: nil)
                    }))
                    self.present(actionSheetController, animated:true, completion:nil)
                }
            }
        }
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
        } else {
            if selectedIndex >= 0 {
                if textFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                    Progress.instance.displayAlert(userMessage: "Please enter service price")
                } else {
                    if isEdited {
                        let service = self.savedServices[selectedIndex]
                        let obj = ServicesData(name: service.name, serviceId: service.serviceId, price: Int((textFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines))!))
                        self.savedServices.remove(at: selectedIndex)
                        self.savedServices.append(obj)
                    } else {
                        let service = self.selectedSuggestedServices[selectedIndex]
                        let obj = ServicesData(name: service.name, serviceId: "\(service.serviceId ?? 0)", price: Int((textFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines))!))
                        self.savedServices.append(obj)
                        self.selectedSuggestedServices.remove(at: selectedIndex)
                    }
                    self.setData()
                }
            } else {
                let obj = ServicesData(name: textFldServiceName.text?.trimmingCharacters(in: .whitespacesAndNewlines), serviceId: "C", price: Int((textFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines))!))
                self.savedServices.append(obj)
                self.setData()
            }
        }
    }
    
    func setData() {
        self.isEdited=false
        self.textFldServiceName.isEnabled=true
        self.textFldServiceName.text = ""
        self.collectionView.reloadData()
        self.tableView.reloadData()
        self.textFldPrice.text = ""
        self.selectedIndex = -1
    }
}

extension AddServicesVC :UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize = (self.selectedSuggestedServices?[indexPath.item].name!)!.size(withAttributes: [NSAttributedStringKey.font: UIFont(name: Constants.AppFont.fontAvenirBook, size: 12.0)!])
        return CGSize(width: size.width + 45.0, height: collectionView.frame.size.height)
    }
}

extension AddServicesVC :UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedServices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MyServicesCell else {
            return MyServicesCell()
        }
        cell.lblTitle.text = self.savedServices[indexPath.row].name
        cell.lblPrice.text = "$\(self.savedServices[indexPath.row].price!)"
        cell.btnEditOut.addTarget(self, action: #selector(editFunc(sender:)), for: .touchUpInside)
        cell.btnDeleteOut.addTarget(self, action: #selector(deleteFunc(sender:)), for: .touchUpInside)
        cell.bgView.backgroundColor = indexPath.row % 2 == 0 ? .white : UIColor(red: 246/255.0, green: 247/255.0, blue: 248/255.0, alpha: 1)
        cell.btnEditOut.tag = indexPath.row
        cell.btnDeleteOut.tag = indexPath.row
        return cell
    }
    
    @objc func editFunc(sender:UIButton) {
        print(sender.tag)
        isEdited = true
        self.textFldServiceName.text = self.savedServices[sender.tag].name              
        self.textFldServiceName.isEnabled=false
        self.selectedIndex = sender.tag
        self.textFldPrice.text = "\(self.savedServices[sender.tag].price ?? 0)"
        self.textFldPrice.becomeFirstResponder()
    }
    
    @objc func deleteFunc(sender:UIButton) {
        print(sender.tag)
        let id = self.savedServices[sender.tag].serviceId
        if self.savedServices[sender.tag].serviceId != "C" {
            let index = self.suggestedServices.enumerated().filter {
                $0.element.serviceId == Int(id!)
                }.map{$0.offset}
            if index.count > 0 {
                self.selectedSuggestedServices.append(self.suggestedServices[index[0]])
                self.collectionView.reloadData()
            }
        }
        self.savedServices.remove(at:sender.tag)
        self.tableView.reloadData()
    }
}

class AddServicesCell :UICollectionViewCell {
    @IBOutlet weak var lblTitle :UILabel!
    @IBOutlet weak var bgView :UIView!

    override func awakeFromNib() {
        bgView.layer.borderColor = UIColor.white.cgColor
        bgView.layer.borderWidth = 1
    }
}

extension AddServicesVC: UITextFieldDelegate {

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
        /*if textField==textFldPrice {
            if string.hasPrefix("0") {
                return false
            }
        }*/
        return true
    }
}

 class MyServicesCell :UITableViewCell {
    @IBOutlet weak var lblTitle :UILabel!
    @IBOutlet weak var lblPrice :UILabel!
    @IBOutlet weak var bgView :UIView!
    @IBOutlet weak var btnEditOut: UIButton!
    @IBOutlet weak var btnDeleteOut: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.borderWidth = 1.0
        bgView.borderColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
}


