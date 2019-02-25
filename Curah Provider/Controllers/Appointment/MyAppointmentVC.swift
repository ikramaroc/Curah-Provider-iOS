//
//  MyAppointmentVC.swift
//  QurahApp
//
//  Created by netset on 7/30/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import FSCalendar

class MyAppointmentVC: BaseClass {
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    @IBOutlet weak var lblCurrentMonth: UILabel!
    @IBOutlet weak var lblCurrentYear: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tblVwAppointments: UITableView!
    let mnthsName = Calendar.current.monthSymbols
    var providerAppointments : [ProviderAppointment] = []
    var noHistoryDataLbl : UILabel?
    var bookingId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Appointments"
        super.setupMenuBarButton()
        self.noDataLbl()
        tblVwAppointments.estimatedRowHeight = 60
        tblVwAppointments.rowHeight = UITableViewAutomaticDimension
        self.tblVwAppointments.isHidden = true
        self.setUpCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // self.tblVwAppointments.backgroundColor = .green
        let date = self.getFormattedString(selectedDate: Date())
        self.getAppointments(formattedDate: date)
    }
    
    func setUpCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesUpperCase]
        calendar.appearance.weekdayTextColor = UIColor.black.withAlphaComponent(0.85)
        calendar.appearance.weekdayFont = UIFont(name: Constants.AppFont.fontAvenirMedium, size: 13.0)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 12.0)
        calendar.calendarWeekdayView.backgroundColor = UIColor.init(hexString: "#F2F3F4")
        calendar.allowsMultipleSelection = true
        calendar.firstWeekday = 2
        calendar.headerHeight = 0
        calendar.weekdayHeight = 40
        calendar.appearance.selectionColor = Constants.appColor.appColorMainGreen
        self.setCurrentMonthInLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCurrentMonthInLabel() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        lblCurrentYear.text = String(year)
        let month = calendar.component(.month, from: date)
        lblCurrentMonth.text = mnthsName[month-1]
    }
    
    func getAppointments(formattedDate:String)  {
        APIManager.sharedInstance.getAppointmentsAPI(date: formattedDate) { (response) in
            if response.status == 200 {
                self.providerAppointments = response.providerAppointment!
                self.tblVwAppointments.isHidden = false
                self.noHistoryDataLbl?.isHidden = true
            } else {
                self.noDataLbl()
                self.tblVwAppointments.isHidden = true
                self.noHistoryDataLbl?.isHidden = false
            }
            self.tblVwAppointments.reloadData()
        }
    }
    
    func noDataLbl()
    {
        let originY = navigationController?.navigationBar.frame.maxY
        if noHistoryDataLbl == nil {
            noHistoryDataLbl = UILabel(frame: CGRect(x: 0, y: self.tblVwAppointments.frame.origin.y + originY! , width: self.view.frame.size.width, height: self.tblVwAppointments.frame.size.height - originY!))
            self.view.addSubview(noHistoryDataLbl!)
        }
        noHistoryDataLbl?.backgroundColor = UIColor.clear
        noHistoryDataLbl?.textColor = UIColor.black
        noHistoryDataLbl?.font = UIFont(name: Constants.AppFont.fontAvenirRoman, size: 18)
        noHistoryDataLbl?.text = "No data found"
        noHistoryDataLbl?.isHidden = false
        noHistoryDataLbl?.textAlignment = .center
       // noHistoryDataLbl?.backgroundColor = .red
        self.tblVwAppointments.isHidden = true
    }
    
    func getFormattedString(selectedDate:Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: selectedDate)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueServicesDetailVC" {
            let objVC : ServiceDetailsVC = segue.destination as! ServiceDetailsVC
            objVC.detail = sender as? ModalBase
            objVC.bookingId = bookingId
        }
    }
}

extension MyAppointmentVC :  FSCalendarDataSource {
    // MARK:- FSCalendarDataSource
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        lblCurrentMonth.text = mnthsName[month-1]
        let year = Calendar.current.component(.year, from: currentPageDate)
        lblCurrentYear.text = String(year)
    }
}


extension MyAppointmentVC :  FSCalendarDelegate {
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        //self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.getAppointments(formattedDate: self.getFormattedString(selectedDate: date))
        // print("did select date \(self.formatter.string(from: date))")
        // self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        // print("did deselect date \(self.formatter.string(from: date))")
        // self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
}



extension MyAppointmentVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providerAppointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CellAppointmentList = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellAppointmentList
        return self.configureCell(cell: cell, indexpath: indexPath)
    }
    
    func configureCell(cell:CellAppointmentList, indexpath:IndexPath) -> UITableViewCell {
        cell.selectionStyle = .none
        super.setUpButtonShadow(btn: cell.btnCancelAppointmentOut)
        let list = self.providerAppointments[indexpath.row]
        cell.lblDateTime.text = super.changeDateFormat(strDate: list.date!) + " " + super.changeTimeFormat(strDate: list.start_time!) + " to " + super.changeTimeFormat(strDate: list.close_time!)
        cell.lblServicesName.text = list.service_name
        cell.btnHeightConst.constant = 35
        cell.btnCancelAppointmentOut.isHidden=false
        cell.lblServiceStatus.textColor = UIColor.black.withAlphaComponent(0.9)
        cell.btnCancelAppointmentOut.tag = indexpath.row
        cell.btnCancelAppointmentOut.addTarget(self, action: #selector(cancelAppoinmentAct), for: .touchUpInside)
        switch list.status {
        case BookingStatus.inProgress.rawValue:
            cell.btnCancelAppointmentOut.setTitle(Param.endService.rawValue, for: .normal)
            cell.lblServiceStatus.text = "In Progress"
            break
        case BookingStatus.accept.rawValue:
            cell.btnCancelAppointmentOut.setTitle(Param.startService.rawValue, for: .normal)
            cell.lblServiceStatus.text = "Accepted"
            break
        case BookingStatus.inProgress.rawValue:
            cell.btnHeightConst.constant = 0
            cell.btnCancelAppointmentOut.isHidden=true
            cell.lblServiceStatus.text = (list.cancel_by == Param.customer.rawValue) ? "Cancelled by me"  :  "Cancelled by provider"
            break
        default:
            cell.lblServiceStatus.text = "Status not defined"
            break
        }
        
        /* switch indexpath.row {
         case 0:
         cell.lblDateTime.text = "25 May, 2018 10:00 am to 11:00 am"
         cell.lblServicesName.text = "Updo, Braid"
         cell.lblServiceStatus.text = "In-Progress"
         cell.btnCancelAppointmentOut.setTitle("End Service", for: .normal)
         cell.lblServiceStatus.textColor = Constants.appColor.appColorMainGreen
         break
         case 1:
         cell.lblServiceStatus.text = "Accepted"
         cell.lblDateTime.text = "25 May, 2018 12:00 pm to 1:00 pm"
         cell.lblServicesName.text = "Hair Color"
         cell.btnHeightConst.constant = 35
         cell.btnCancelAppointmentOut.isHidden=false
         cell.btnCancelAppointmentOut.setTitle("Start Service", for: .normal)
         cell.lblServiceStatus.textColor = UIColor.black.withAlphaComponent(0.9)
         break
         case 2:
         cell.lblServiceStatus.text = "Accepted"
         cell.lblDateTime.text = "25 May, 2018 10:00 am to 11:00 am"
         cell.lblServicesName.text = "Blow Out"
         cell.btnHeightConst.constant = 35
         cell.btnCancelAppointmentOut.isHidden=false
         cell.btnCancelAppointmentOut.setTitle("Start Service", for: .normal)
         cell.lblServiceStatus.textColor = UIColor.black.withAlphaComponent(0.9)
         break
         default:
         break
         }*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            self.performSegue(withIdentifier: "segueServicesDetailVC", sender: "3")
//        } else {
//            self.performSegue(withIdentifier: "segueServicesDetailVC", sender: "2")
//        }
        
        let list = self.providerAppointments[indexPath.row]
        self.getAppoitmentDetailAPI(id: list.bookingId!)
        bookingId = list.bookingId!
        
    }
    
    // MARK:- Get AppoitmentDetail API
    func getAppoitmentDetailAPI(id:Int) {
        APIManager.sharedInstance.appointmentDetailAPI(bookingId: id) { (response) in
            self.performSegue(withIdentifier: "segueServicesDetailVC", sender: response)
        }
    }
    
    
    @objc func cancelAppoinmentAct(sender: UIButton) {
        if sender.title(for: .normal) == Param.startService.rawValue {
            let list = self.providerAppointments[sender.tag]
            APIManager.sharedInstance.startServiceAPI(bookingId: list.bookingId!) { (response) in
                
                let date = self.getFormattedString(selectedDate: Date())
                self.getAppointments(formattedDate: date)
                
            }
        } else if sender.title(for: .normal) == Param.endService.rawValue {
            let list = self.providerAppointments[sender.tag]
            APIManager.sharedInstance.startServiceAPI(bookingId: list.bookingId!) { (response) in
                self.providerAppointments.remove(at: sender.tag)
                if response.status == 200 {
                    self.providerAppointments = response.providerAppointment!
                    self.tblVwAppointments.isHidden = false
                    self.noHistoryDataLbl?.isHidden = true
                } else {
                    self.noDataLbl()
                    self.tblVwAppointments.isHidden = true
                    self.noHistoryDataLbl?.isHidden = false
                }
                self.tblVwAppointments.reloadData()
            }
        }
        // self.performSegue(withIdentifier: segueId.cancelAppointment.rawValue, sender: sender.tag)
    }
}

class CellAppointmentList: UITableViewCell {
    @IBOutlet weak var btnCancelAppointmentOut: UIButton!
    @IBOutlet weak var lblServiceStatus: UILabel!
    @IBOutlet weak var lblServicesName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnHeightConst: NSLayoutConstraint!
    
}
