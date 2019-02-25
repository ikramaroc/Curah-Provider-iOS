//
//  HomeVC.swift
//  Curah Provider
//
//  Created by Netset on 30/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

class HomeVC: BaseClass,UITableViewDataSource,UITableViewDelegate {
    fileprivate var newAppointmentList : ModalBase!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNoServices: UILabel!
    @IBOutlet weak var btnEndService: UIButton!
    @IBOutlet weak var noAppointmentLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupMenuBarButton()
        title = "Home"
        //tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: NSNotification.Name(rawValue: "RefreshNotification"), object: nil)
        
       // self.tableView.tableFooterView = UIView()
    }
    
    //MARK:- Notification Method
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.getNewAppointments()
    }
    
    
    func setUpInProgressAppointment() {
        guard self.newAppointmentList != nil else {
            return
        }
        let list = self.newAppointmentList.inProcessService
        self.hideShowData(isHidden: true)
        if list?.serviceName != nil {
            self.lblServiceName.text = list?.serviceName
            self.lblTime.text = super.changeTimeFormat(strDate: (list?.startTime)!) + " - " +  super.changeTimeFormat(strDate: (list?.closeTime)!)
            self.hideShowData(isHidden: false)
        }
    }
    
    func hideShowData(isHidden:Bool) {
        lblServiceName.isHidden = isHidden
        lblTime.isHidden = isHidden
        btnEndService.isHidden = isHidden
        lblNoServices.isHidden = !isHidden
    }
    
    @IBAction func btnEndServiceAct(_ sender: Any) {
        APIManager.sharedInstance.endAppointmentAPI(bookingId: (self.newAppointmentList.inProcessService?.bookingId)!) { (response) in
            self.newAppointmentList.inProcessService = nil
            self.setUpInProgressAppointment()
            self.getNewAppointments()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentScreenStr = "HomeVC"
        self.getNewAppointments()
    }

    override func viewDidDisappear(_ animated: Bool) {
       currentScreenStr = ""
        NotificationCenter.default.removeObserver(self)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.newAppointmentList != nil else {
            return 0
        }
        return ((self.newAppointmentList.appointments?.count)! == 0) ? 0 : (self.newAppointmentList.appointments?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if (self.newAppointmentList.appointments?.count)! == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell")
//            cell?.selectionStyle = .none
//            return cell!
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeCell
        let list = self.newAppointmentList.appointments![indexPath.row]
        cell.lblDateAndTime.text = super.changeDateFormat(strDate: list.date!) + " " + super.changeTimeFormat(strDate: list.startTime!) + " to " + super.changeTimeFormat(strDate: list.closeTime!)
        cell.lblServiceName.text = list.serviceName
        super.setUpButtonShadow(btn: cell.btnReject)
        super.setUpButtonShadow(btn: cell.btnAccept)
        cell.btnAccept.addTarget(self, action: #selector(acceptAppointment(sender:)), for: .touchUpInside)
        cell.btnReject.addTarget(self, action: #selector(rejectAppointment(sender:)), for: .touchUpInside)
        cell.btnAccept.tag = indexPath.row
        cell.btnReject.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func acceptAppointment(sender:UIButton) {
        print(sender.tag)
        APIManager.sharedInstance.acceptRejectAppointmentsAPI(bookingId: self.newAppointmentList.appointments![sender.tag].bookingId!, status: Param.accept.rawValue) { (response) in
            
            if response.status! == 200 {
            self.newAppointmentList.appointments?.remove(at: sender.tag)
            self.tableView.reloadData()
            }else if response.status! == 404{
                Progress.instance.displayAlert(userMessage: response.message!)
            }
            print(response)
        }
    }
    
    @objc func rejectAppointment(sender:UIButton) {
        APIManager.sharedInstance.acceptRejectAppointmentsAPI(bookingId: self.newAppointmentList.appointments![sender.tag].bookingId!, status: Param.reject.rawValue) { (response) in
            self.newAppointmentList.appointments?.remove(at: sender.tag)
            self.tableView.reloadData()
            print(response)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.newAppointmentList.appointments?.count)! != 0 {
            
            //self.performSegue(withIdentifier: "segueServiceDetail", sender: nil)
            let list = self.newAppointmentList.appointments?[indexPath.row]
            getAppoitmentDetailAPI(id: (list?.bookingId!)!)
            
        }
    }
    
    // MARK:- Get AppoitmentDetail API
    func getAppoitmentDetailAPI(id:Int) {
        APIManager.sharedInstance.appointmentDetailAPI(bookingId: id) { (response) in
            self.performSegue(withIdentifier: "segueDetailVC", sender: response)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((self.newAppointmentList.appointments?.count)! == 0) ?  (tableView.frame.size.height-64) : UITableViewAutomaticDimension
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetailVC" {
            let objVC : ServiceDetailsVC = segue.destination as! ServiceDetailsVC
           objVC.detail = sender as? ModalBase
        }
    }
    
    
    
    
    func getNewAppointments()  {
        APIManager.sharedInstance.newAppointmentsAPI { (response) in
            self.newAppointmentList = response
            self.tableView.reloadData()
            
            if (self.newAppointmentList.appointments?.count == 0){
                self.tableView.isHidden = true
                self.noAppointmentLbl.isHidden = false
            }else{
                self.tableView.isHidden = false
                self.noAppointmentLbl.isHidden = true
            }
            
            DispatchQueue.main.async {
                self.setUpInProgressAppointment()
            }
        }
    }
}

class HomeCell: UITableViewCell {
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var lblServiceName: UILabel!
}
