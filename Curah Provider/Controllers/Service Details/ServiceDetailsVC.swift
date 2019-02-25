//
//  ServiceDetailsVC.swift
//  QurahApp
//
//  Created by netset on 7/18/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import FloatRatingView

enum status : String {
    case isRejected = "R"
    case isAccepted = "A"
    case isPending = "P"
    case isCancelled = "K"
    case isInProgress = "I"
    case isCompleted = "C"
    
    
    
    //    case isWaiting = "P"
    //    case isAccepted = "A"
    //    case isProgress = "3"
    //    case isCompleted = "4"
    //    case isCancelled = "K"
    case viewReceipt = "VIEW RECEIPT"
    case reject = "REJECT"
    case accept = "ACCEPT"
    case cancel = "CANCEL SERVICE"
    case start = "START SERVICE"
    case end = "END SERVICE"
}

class ServiceDetailsVC: BaseClass {
    
    
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var viewForCancelService: UIView!
    
    @IBOutlet weak var stackHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewReasonBottomConst: NSLayoutConstraint!
    @IBOutlet weak var lblStatusHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnCancelHeightConst: NSLayoutConstraint!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var viewAtFooter: UIView!
    @IBOutlet weak var tblVwDetails: UITableView!
    @IBOutlet weak var cancelReasonLbl: UILabel!
    
    var bookingId = Int()
    var detail: ModalBase!
    var strStatus:String!
    let identifiers = ["cellServicesNamePrice", "cellServiceDetails" , "cellServiceDescription", "cellBarberDetails","cellFeedback"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        super.setupBackBtn(tintClr: .white)
        tblVwDetails.tableFooterView = UIView()
        tblVwDetails.rowHeight = UITableViewAutomaticDimension
        
        //service details notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: NSNotification.Name(rawValue: "RefreshNotification"), object: nil)
        
        setData()
    }
    
    //MARK:- Notification Method
    @objc func methodOfReceivedNotification(notification: Notification) {
        getAppoitmentDetailAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bookingIdForNotification = (detail.appointmentDetails?.bookingId!)!
        currentScreenStr = "ServiceDetailsVC"
        if fromPushNotification{
            getAppoitmentDetailAPI()
        }
        fromPushNotification = false
        //        else{
        //            detail.appointmentDetails?.bookingId = bookingId
        //        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        currentScreenStr = ""
        NotificationCenter.default.removeObserver(self)
    }
    
    func setData() {
        
        strStatus = detail.appointmentDetails?.status
        btnSecond.isHidden = true
        btnFirst.isHidden = true
        viewReasonBottomConst.constant = 0
        lblStatusHeightConst.constant = 45
        tblVwDetails.estimatedRowHeight = 50
      //  stackHeightConstant.constant = 0
        if strStatus == status.isPending.rawValue {
            //self.setView(title: "Your appointment is waiting for response.", color: UIColor.black, btnReasonHeight: -200, btnCancelHeight: 50)
            lblStatusHeightConst.constant = 0
            labelStatus.text = ""
            btnFirst.isHidden = false
             stackHeightConstant.constant = 50
            btnSecond.isHidden=false
            btnFirst.setTitle(status.reject.rawValue, for: .normal)
            btnSecond.setTitle(status.accept.rawValue, for: .normal)
            viewReasonBottomConst.constant = -62
        } else if strStatus == status.isAccepted.rawValue {
            // labelStatus.text = "Your appointment has been accepted."
            // viewReasonBottomConst.constant = -62
//              stackHeightConstant.constant = 0
            lblStatusHeightConst.constant = 0
            labelStatus.text = ""
            btnSecond.isHidden=false
            btnFirst.isHidden = false
             stackHeightConstant.constant = 50
            btnFirst.setTitle(status.cancel.rawValue, for: .normal)
            btnSecond.setTitle(status.start.rawValue, for: .normal)
            viewReasonBottomConst.constant = -62
            
            //  self.setView(title: "Your appointment has been accepted", color: UIColor.black, btnReasonHeight: -200, btnCancelHeight: 50)
        } else if strStatus == status.isInProgress.rawValue {
            lblStatusHeightConst.constant = 0
             stackHeightConstant.constant = 50
            labelStatus.text = ""
            btnFirst.isHidden = false
            btnFirst.setTitle(status.end.rawValue, for: .normal)
            viewReasonBottomConst.constant = -62
            // self.setView(title: "Your service is in progress", color: Constants.appColor.appColorMainGreen, btnReasonHeight: -200, btnCancelHeight: 0)
        }  else if strStatus == status.isCompleted.rawValue {
            labelStatus.text = ""
            btnFirst.isHidden = false
            btnFirst.setTitle(status.viewReceipt.rawValue, for: .normal)
            viewReasonBottomConst.constant = -62
            // self.setView(title: "", color: Constants.appColor.appColorMainGreen, btnReasonHeight: -200, btnCancelHeight: 0)
            lblStatusHeightConst.constant = 0
//             stackHeightConstant.constant = 0
            if detail.rating?.customerMessage!.count == 0{
                let newVc = self.storyboard?.instantiateViewController(withIdentifier: "RateReviewPopUpVC") as! RateReviewPopUpVC
                newVc.bookingId = (detail.appointmentDetails?.bookingId)!
                newVc.otherUserId = (detail.appointmentDetails?.userId)!
                newVc.delegate = self
                newVc.providesPresentationContextTransitionStyle = true
                newVc.definesPresentationContext = true
                newVc.modalPresentationStyle = .overCurrentContext
                self.present(newVc, animated: true, completion: nil)
            }
            
        } else if strStatus == status.isCancelled.rawValue {
            self.viewAtFooter.isHidden = false
            stackHeightConstant.constant = 0
//            viewReasonBottomConst.constant = -62
            DispatchQueue.main.async {
                if self.detail.appointmentDetails?.cancelBy! == "C"{
                    self.viewForCancelService.isHidden = false
                    self.cancelReasonLbl.text = self.detail.appointmentDetails?.cancelDescription! ?? ""
                    self.labelStatus.text = "Customer have cancelled the appointment."
                }else{
                    self.viewForCancelService.isHidden = false
                    self.cancelReasonLbl.text = self.detail.appointmentDetails?.cancelDescription! ?? ""
                    self.labelStatus.text = "You have cancelled the appointment."
                }
            }
            
            //            btnCancelHeightConst.constant = 0
           
        }
        else if strStatus == status.isRejected.rawValue {
            self.viewForCancelService.isHidden = true
             stackHeightConstant.constant = 0
            //            btnCancelHeightConst.constant = 0
            viewForCancelService.isHidden = true
            cancelReasonLbl.text = ""
            labelStatus.text = "You have rejected the Service."
        }
        
    }
    
    func setView(title:String, color:UIColor, btnReasonHeight:Int, btnCancelHeight:CGFloat) {
        labelStatus.text = title
        labelStatus.textColor = color
        viewReasonBottomConst.constant = CGFloat(btnReasonHeight)
        //        btnCancelHeightConst.constant = btnCancelHeight
    }
    
    @IBAction func btnFirstAct(_ sender: UIButton) {
        if sender.titleLabel?.text == status.reject.rawValue{
            APIManager.sharedInstance.acceptRejectAppointmentsAPI(bookingId: (detail.appointmentDetails?.bookingId!)!, status: Param.reject.rawValue) { (response) in
                print(response)
                self.getAppoitmentDetailAPI()
            }
        }
        
        if sender.titleLabel?.text == status.cancel.rawValue{
            
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CancelAppointmentPopupVC") as! CancelAppointmentPopupVC
            newVC.objProtocol = self
            newVC.bookingId = (detail.appointmentDetails?.bookingId!)!
            newVC.providesPresentationContextTransitionStyle = true
            newVC.definesPresentationContext = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.present(newVC, animated: true, completion: nil)
//            self.navigationController?.pushViewController(newVC, animated: true)
            
            //            self.performSegue(withIdentifier: "segueCancelAppointmentVC", sender: nil)
        }
        
        if sender.titleLabel?.text == status.viewReceipt.rawValue{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
            
            //            var receiptDataArray = [ReceiptArray(name: self.detail.appointmentDetails?.serviceName ?? "", price: self.detail.appointmentDetails?.price!)]
            vc.payablePrice = Double((detail.appointmentDetails?.getPrice)!)
            vc.array = (detail.appointmentDetails?.serviceNameArr)!
            vc.totalPrice = (detail.appointmentDetails?.price)!
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            //  self.performSegue(withIdentifier: "segueViewReceiptVC", sender: nil)
            
        }
        if sender.titleLabel?.text == status.end.rawValue{
            APIManager.sharedInstance.endAppointmentAPI(bookingId: (detail.appointmentDetails?.bookingId!)!) { (response) in
                self.getAppoitmentDetailAPI()
            }
            
        }
        
        
    }
    
    
    @IBAction func btnSecondAct(_ sender: UIButton) {
        if sender.titleLabel?.text == status.accept.rawValue{
            APIManager.sharedInstance.acceptRejectAppointmentsAPI(bookingId:(detail.appointmentDetails?.bookingId!)!, status: Param.accept.rawValue) { (response) in
                if response.status! == 200 {
                    self.getAppoitmentDetailAPI()
                }else if response.status! == 404{
                    Progress.instance.displayAlert(userMessage: response.message!)
                }
                print(response)
            }
            
        }
        
        if sender.titleLabel?.text == status.start.rawValue{
            APIManager.sharedInstance.startServiceAPI(bookingId: (detail.appointmentDetails?.bookingId!)!) { (response) in
                DispatchQueue.main.async {
                   self.getAppoitmentDetailAPI()
                }
                
                print(response)
            }
        }
        getAppoitmentDetailAPI()
    }
    
    // MARK:- Get AppoitmentDetail API
    func getAppoitmentDetailAPI() {
        if bookingId == 0{
            bookingId = (detail.appointmentDetails?.bookingId!)!
            
        }
        APIManager.sharedInstance.appointmentDetailAPI(bookingId: bookingId) { (response) in
            self.detail = response
            self.tblVwDetails.reloadData()
            self.setData()
        }
        
    }
    
    
    
    
    
    @IBAction func btnCancelAppointAct(_ sender: Any) {
        
        if btnFirst.titleLabel?.text == status.start.rawValue{
            APIManager.sharedInstance.startServiceAPI(bookingId: (detail.appointmentDetails?.bookingId!)!) { (response) in
                self.getAppoitmentDetailAPI()
                print(response)
            }
        }
        
       else if btnFirst.titleLabel?.text == status.viewReceipt.rawValue {
            self.performSegue(withIdentifier: "segueViewReceiptVC", sender: nil)
        } else if btnFirst.titleLabel?.text == status.cancel.rawValue {
            self.performSegue(withIdentifier: "segueCancelAppointmentVC", sender: nil)
        } else if btnFirst.titleLabel?.text == status.end.rawValue {
            let newVc = self.storyboard?.instantiateViewController(withIdentifier: "RateReviewPopUpVC") as! RateReviewPopUpVC
            newVc.bookingId = (detail.appointmentDetails?.bookingId)!
            newVc.otherUserId = (detail.appointmentDetails?.userId)!
            newVc.delegate = self
            newVc.providesPresentationContextTransitionStyle = true
            newVc.definesPresentationContext = true
            newVc.modalPresentationStyle = .overCurrentContext
            self.present(newVc, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ServiceDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard self.detail != nil else {
                return 0
            }
            return detail.appointmentDetails?.serviceNameArr?.count == 0 ? 0 : (detail.appointmentDetails?.serviceNameArr?.count)!
        case 1:
            return 3
        case 2:
            return 0
        case 3:
            return 1
        case 4:
            return 2
        default:
            break
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return identifiers.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section])
        if indexPath.section == 0 {
            cell?.selectionStyle = .none
            return self.configureCell(cell: cell!, indexpath: indexPath)
        } else if indexPath.section == 1 {

            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "SERVICE COST"
                cell?.detailTextLabel?.text = "$\(detail.appointmentDetails!.price!)"
                break
            case 1:
                cell?.textLabel?.text = "DATE"
                cell?.detailTextLabel?.text = super.changeDateFormat(strDate: (detail.appointmentDetails?.date!)!)
                break
            case 2:
                cell?.textLabel?.text = "TIME"
                cell?.detailTextLabel?.text = super.changeTimeFormat(strDate: (detail.appointmentDetails?.startTime!)!) + " to " + super.changeTimeFormat(strDate: (detail.appointmentDetails?.closeTime!)!)//"11:00 am to 12:00 pm"
                break
            default:
                break
            }
        } else if indexPath.section == 2 {
            
            let cell : CellServiceDescription = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section]) as! CellServiceDescription
            cell.descriptionLbl.text = (detail.appointmentDetails?.description) ?? ""

            return cell
        } else if indexPath.section == 3 {
            let cell : CellBarberDetailsList = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section]) as! CellBarberDetailsList

            return self.configureCell(cell: cell, indexpath: indexPath)
        } else if indexPath.section == 4 {
            let cell : CellFeedbackDetails = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section]) as! CellFeedbackDetails
            return self.configureFeedbackCell(cell: cell, indexpath: indexPath)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func configureCell(cell:UITableViewCell, indexpath:IndexPath) -> UITableViewCell {
        let viewAtBack : UIView = (cell.viewWithTag(1))!
        viewAtBack.borderWidth = 1.0
        viewAtBack.borderColor = UIColor.lightGray.withAlphaComponent(0.4)
        viewAtBack.clipsToBounds=true
        viewAtBack.backgroundColor = (indexpath.row%2==0) ? UIColor.clear : UIColor.lightGray.withAlphaComponent(0.07)
        let lblServiceName : UILabel = (cell.viewWithTag(2) as? UILabel)!
        let lblServicePrice : UILabel = (cell.viewWithTag(3) as? UILabel)!
        let data = (detail.appointmentDetails?.serviceNameArr?[indexpath.row])!
        lblServiceName.text = data.name
        lblServicePrice.text =  "$" + data.price!
        return cell
    }
    
    func configureFeedbackCell(cell:CellFeedbackDetails, indexpath:IndexPath) -> UITableViewCell {
        switch indexpath.row {
        case 0:
            cell.lblTitle.text = "Your feedback to Customer"
            cell.lblReview.text = detail.rating?.customerMessage!
            if let rating = detail.rating?.customerRating {
                cell.ratingView.rating = Double(rating)
            }
            break
        case 1:
            cell.lblTitle.text = "Customer feedback to you."
            cell.lblReview.text = detail.rating?.providerMessage!
            if let rating = detail.rating?.providerRating {
                cell.ratingView.rating = Double(rating)
            }
            break
        default:
            break
        }
        return cell
    }
    
    func configureCell(cell:CellBarberDetailsList, indexpath:IndexPath) -> UITableViewCell {
        cell.imgVwUser.clipsToBounds=true
        cell.imgVwUser.layer.cornerRadius = 3.0
        cell.imgVwUser.layer.borderColor = UIColor.black.cgColor
        cell.imgVwUser.layer.borderWidth = 0.7
        cell.selectionStyle = .none
        let userData = detail.appointmentDetails?.userDetails
        
        
        cell.lblUserName.text = (userData?.firstname)!
        if !(userData?.profileImage?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: cell.imgVwUser.bounds.size.width/2, y: cell.imgVwUser.bounds.size.height/2)
            activityView.color = Constants.appColor.appColorMainPurple
            activityView.startAnimating()
            cell.imgVwUser.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (detail.imgUrl)! as String + (userData?.profileImage)! as String, completionHandler:{(image: UIImage?, url: String) in
                cell.imgVwUser.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        cell.btnChat.addTarget(self, action: #selector(chatAct), for: .touchUpInside)
        cell.btnCall.addTarget(self, action: #selector(callAct), for: .touchUpInside)
        cell.lblDistance.text  = "(\(userData?.distance ?? 0) miles away)"
        if let rating = userData?.rating {
            cell.ratingView.rating = Double(rating)!
        }
        return cell
    }
    
    @objc func chatAct() {
        
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        newViewController.connection_id = (detail.appointmentDetails?.userDetails?.connection_id ?? 0)
        newViewController.receiver_id = detail.appointmentDetails?.userDetails?.id
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    @objc func callAct() {
        let phoneNo = self.detail.appointmentDetails?.userDetails?.phone
        if let url = URL(string: "tel://\(phoneNo ?? "0")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            Progress.instance.displayAlert(userMessage:"Your device doesn't support this feature.")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if strStatus != status.isCompleted.rawValue {
            if indexPath.section == 4 {
                return 0
            }
        }
        if indexPath.section == 0 || indexPath.section == 1 {
            return 60
        }
        return UITableViewAutomaticDimension
    }
    
    /*func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
     return 0.001
     }*/
}

extension ServiceDetailsVC:reloadServiceDataProtocol{
    func reloadData() {
        getAppoitmentDetailAPI()
    }
}
extension ServiceDetailsVC:CallbackCancelAppointment{
    func reloadAppointmentDetailData(reason: String) {
        getAppoitmentDetailAPI()
    }
    
    
}


class CellBarberDetailsList: UITableViewCell {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
}

class CellFeedbackDetails: UITableViewCell {
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
}
class CellServiceDescription: UITableViewCell {
    @IBOutlet weak var descriptionLbl: UILabel!
}
