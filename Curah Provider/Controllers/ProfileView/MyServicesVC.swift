//
//  MyServicesVC.swift
//  CurahApp
//
//  Created by Netset on 28/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

class MyServicesVC: UIViewController,passAddServicesDataProtocol {
    
    var services = [Services]()
    @IBOutlet weak var bottonLblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var alertTitleLbl: UILabel!
    var isUpdated = false
    var servicesDataArray = [ServicesData]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getServicesList()
    }
    
    func getServicesList(){
        
        APIManager.sharedInstance.getServicesListAPI{ (response) in
            self.services = response.services!
            
            self.bottonLblHeightConstant.constant = 0
            self.alertTitleLbl.isHidden = true
            
            for service in self.services{
                if service.isApproved == 0{
                    self.bottonLblHeightConstant.constant = 40
                    self.alertTitleLbl.isHidden = false
                }
//                else{
//                    self.bottonLblHeightConstant.constant = 0
//                    self.alertTitleLbl.isHidden = true
//                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnAddNewServicesAct(_ sender: Any) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AddservicesPopUpViewController") as! AddservicesPopUpViewController
        viewController.delegate = self
        viewController.userServices = services
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    func refreshData() {
        isUpdated = true
        self.services.removeAll()
        
        getServicesList()
  
    }
    
    
    //    //MARK:- Suggested Services API *******
    //    func fetchSuggestedServicesAPI() {
    //        APIManager.sharedInstance.getUserServicesAPI() { (response) in
    //            self.services?.removeAll()
    //            self.services = response.services
    //            self.tableView.reloadData()
    //        }
    //    }
    
}

extension MyServicesVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (services.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ServicesCell else {
            return ServicesCell()
        }
        cell.selectionStyle = .none
        return self.configureCell(cell: cell, indexpath: indexPath)
    }
    
    func configureCell(cell:ServicesCell, indexpath:IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ServicesCell else {
            return ServicesCell()
        }
        cell.selectionStyle = .none
        
        cell.lblTitle.text = services[indexpath.row].name
        if services[indexpath.row].isApproved == 1{
            cell.lblTitle.textColor = UIColor(red: 198/255, green: 213/255, blue: 150/255, alpha: 1)
            cell.lblPrice.textColor = UIColor(red: 198/255, green: 213/255, blue: 150/255, alpha: 1)

        }else{
            cell.lblTitle.textColor = .red
            cell.lblPrice.textColor = .red
        }
        
        
        cell.lblPrice.text = "$\(services[indexpath.row].price! ?? 0)"
        cell.btnEditOut.addTarget(self, action: #selector(editAct(sender:)), for: .touchUpInside)
        cell.btnDeleteOut.addTarget(self, action: #selector(deleteAct(sender:)), for: .touchUpInside)
        cell.bgView.backgroundColor = indexpath.row % 2 == 0 ? .white : UIColor(red: 246/255.0, green: 247/255.0, blue: 248/255.0, alpha: 1)
        cell.btnEditOut.tag = indexpath.row
        cell.btnDeleteOut.tag = indexpath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    @objc func editAct(sender:UIButton) {
        print(sender.tag)
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AddservicesPopUpViewController") as! AddservicesPopUpViewController
        viewController.delegate = self
        viewController.userServices = services
        viewController.selectedIndex = sender.tag
        viewController.isEditing = true
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
        
        /* APIManager.sharedInstance.acceptRejectAppointmentsAPI(bookingId: self.newAppointmentList.appointments![sender.tag].bookingId!, status: Param.accept.rawValue) { (response) in
         self.newAppointmentList.appointments?.remove(at: sender.tag)
         self.tableView.reloadData()
         print(response)
         }*/
    }
    
    @objc func deleteAct(sender:UIButton) {
        
        if services[sender.tag].type! == "P" {
            var count = 0
            for services in services{
                if services.type == "P"{
                    count = count + 1
                }
            }
            if count > 1{
                deleteApi(index: sender.tag)
            }else{
                Progress.instance.displayAlert(userMessage: Validation.call.deleteServices)
            }
        }else{
            deleteApi(index: sender.tag)
        }
    }
    
    func deleteApi(index:Int){
        APIManager.sharedInstance.deleteServicesAPI(serviceId: (services[index].serviceId)!) { (response) in
            self.services.removeAll()
            ModalShareInstance.shareInstance.modalUserData.services = response.services
            SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)

            self.services = response.services!
            
            self.bottonLblHeightConstant.constant = 0
            self.alertTitleLbl.isHidden = true
            
            for service in self.services{
                if service.isApproved == 0{
                    self.bottonLblHeightConstant.constant = 40
                    self.alertTitleLbl.isHidden = false
                }
            }
            
            self.tableView.reloadData()
            
            print(response)
        }
    }
}


class ServicesCell :UITableViewCell {
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
