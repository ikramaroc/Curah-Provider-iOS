//
//  ScheduleVC.swift
//  CurahApp
//
//  Created by Netset on 28/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import FSCalendar

let GreenColor = UIColor(red: 206/255.0, green: 219/255.0, blue: 170/255.0, alpha: 1.0)
let GreyColor = UIColor(red: 234/255.0, green: 235/255.0, blue: 236/255.0, alpha: 1.0)

class ScheduleVC: BaseClass,UITextFieldDelegate {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var timeSlotTableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var addMoreBtn: UIButton!
    let mnthsName = Calendar.current.monthSymbols
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    var pickerViewTime = UIDatePicker()
    var timingStr = String()
    var tableCount = 1
    var timingArray = [ScheduleTiming]()
    var timingInMillis = [ScheduleTimingInMillies]()
    var calendarSelectedDate = String()
    var startTime = String()
    var endTime = String()
    var modelObj : ModalBase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMoreBtn.isHidden = true
        
        timingArray.append(ScheduleTiming(startTime: "", endTime: "", appointmentTimeId: 0, status: ""))
        
        timingInMillis.append(ScheduleTimingInMillies(startTime: 0, endTime: 0))
        setCalendar()
        tableViewHeight.constant = 128.5
        pickerViewTime.datePickerMode = .time
        pickerViewTime.addTarget(self, action: #selector(selectTime(_:)), for: .valueChanged)
        
        calendarSelectedDate = convertToLocalOnlyDate(utcDate: Date())
        seeAppointmentOfSelectedDate(date: calendarSelectedDate)
        calendar.select(Date())
        
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let timeValue = isNullCheck(text: timingStr) ?  convertTimeToDate(time: timingStr).millisecondsSince1970 : 0
        
        let currentValue =  convertTimeToDate(time: convertTimeToDateFormatString(time: Date())).millisecondsSince1970
        
        if calendarSelectedDate.count == 0{
            Progress.instance.displayAlert(userMessage:Validation.call.enterCalendarTime)
        }else if (calendarSelectedDate == self.convertToLocalDateFormatOnlyTimeToDateString(utcDate: Date())) &&  currentValue > timeValue  {
            Progress.instance.displayAlert(userMessage:Validation.call.enterValidTime)
        }else {
            let cell = textField.superview?.superview?.superview as! timeSlotCell
            
            if cell.fromTimeTxt == textField{
                startTime = timingStr
                let startValue = isNullCheck(text: startTime) ?  convertTimeToDate(time: startTime).millisecondsSince1970 : 0
                if checkTimeValue(time: startValue, isEndValue: false, index: textField.tag){
                    textField.text = timingStr
                    fillDataToTextfields(cell: cell)
                }
            }
            if cell.toTimeTxt == textField{
                endTime = timingStr
                let endValue = isNullCheck(text: endTime) ?  convertTimeToDate(time: endTime).millisecondsSince1970 : 0
                if checkTimeValue(time: endValue, isEndValue: true, index: textField.tag){
                    textField.text = timingStr
                    fillDataToTextfields(cell: cell)
                }
                addMoreBtn.isHidden = false
            }
        }
        
        
    }
    func fillDataToTextfields(cell:timeSlotCell){
        
        if cell.fromTimeTxt.text == cell.toTimeTxt.text{
            Progress.instance.displayAlert(userMessage:Validation.call.enterValidTime)
        }else if cell.fromTimeTxt.text == ""{
            Progress.instance.displayAlert(userMessage:Validation.call.enterStartTime)
        }else {
            if timingArray.count == cell.fromTimeTxt.tag {
                timingArray[cell.fromTimeTxt.tag] = ScheduleTiming(startTime: cell.fromTimeTxt.text!, endTime: cell.toTimeTxt.text!, appointmentTimeId: 0, status: "")
                
                let startValue = isNullCheck(text: cell.fromTimeTxt.text!) ?  convertTimeToDate(time: cell.fromTimeTxt.text!).millisecondsSince1970 : 0
                
                let endValue = isNullCheck(text: cell.toTimeTxt.text!) ?  convertTimeToDate(time: cell.toTimeTxt.text!).millisecondsSince1970 : 0
                
                timingInMillis[cell.fromTimeTxt.tag] = ScheduleTimingInMillies(startTime: startValue, endTime: endValue)
                
            }else if timingArray.count == cell.fromTimeTxt.tag {
                timingArray.append(ScheduleTiming(startTime: startTime, endTime: endTime, appointmentTimeId: 0, status: ""))
                
                let startValue = isNullCheck(text: startTime) ?  convertTimeToDate(time: cell.fromTimeTxt.text!).millisecondsSince1970 : 0
                
                let endValue = isNullCheck(text: endTime) ?  convertTimeToDate(time: cell.toTimeTxt.text!).millisecondsSince1970 : 0
                
                timingInMillis.append(ScheduleTimingInMillies(startTime: startValue, endTime: endValue))
            }else{
                timingArray[cell.fromTimeTxt.tag] = ScheduleTiming(startTime: cell.fromTimeTxt.text!, endTime: cell.toTimeTxt.text!, appointmentTimeId: 0, status: "")
                let startValue = isNullCheck(text: cell.fromTimeTxt.text!) ?  convertTimeToDate(time: cell.fromTimeTxt.text!).millisecondsSince1970 : 0
                
                let endValue = isNullCheck(text: cell.toTimeTxt.text!) ?  convertTimeToDate(time: cell.toTimeTxt.text!).millisecondsSince1970 : 0
                
                timingInMillis[cell.fromTimeTxt.tag] = ScheduleTimingInMillies(startTime: startValue, endTime: endValue)
            }
        }
        if timingInMillis[timingInMillis.count-1].startTime != 0 && timingInMillis[timingInMillis.count-1].endTime != 0{
            addMoreBtn.isHidden = false
        }else{
            addMoreBtn.isHidden = true
        }
        
    }
    
    func isNullCheck(text:String) -> Bool{
        if text.count == 0{
            return false
        }else{
            return true
        }
    }
    
    func checkTimeValue(time:Int,isEndValue:Bool,index:Int) -> Bool{
        
        
        var isValid = false
        for a in 0...timingInMillis.count-1{
            if (time > timingInMillis[a].startTime && time < timingInMillis[a].endTime ) && (timingInMillis[a].startTime != 0 && timingInMillis[a].endTime != 0) {
                isValid = false
                break
            }else if timingInMillis[a].startTime == 0{
                isValid = true
            }else if timingInMillis[a].endTime == 0 {
                //                if time > timingInMillis[a].startTime{
                //                    isValid = true
                //                }
                //                isValid = false
                //                break
                isValid = true
            }
            //            else{
            //                isValid = true
            //            }
        }
        
        let minimumMilliSec = timingInMillis.sorted { (time1, time2) -> Bool in
            return time1.startTime < time2.startTime
        }
        
        let maximumMilliSec = timingInMillis.sorted { (time1, time2) -> Bool in
            return time1.endTime < time2.endTime
        }
        
        
        
        if isEndValue{
            if timingInMillis[index].startTime > time {
                isValid = false
            }
            
            var minValue = Int()
            var maxValue = Int()
            
            if minimumMilliSec[0].startTime == 0 {
                
                if minimumMilliSec.count > 1{
                    minValue = minimumMilliSec[1].startTime
                }else{
                    minValue = minimumMilliSec[0].startTime
                }
                
                
            }else{
                minValue = minimumMilliSec[0].startTime
            }
            
            if maximumMilliSec[0].endTime == 0 {
                
                if minimumMilliSec.count > 1{
                    maxValue = maximumMilliSec[1].endTime
                }else{
                    maxValue = maximumMilliSec[0].endTime
                }
                
                
            }else{
                maxValue = maximumMilliSec[0].endTime
            }
            
            
            
            if (timingInMillis[index].startTime < minValue || timingInMillis[index].startTime == minValue) && time > maxValue && timingInMillis.count > 1 {
                isValid = false
            }
            
            
            //            if (timingInMillis[index].startTime < minValue || timingInMillis[index].startTime == minValue) && time > maximumMilliSec[0].endTime{
            //                isValid = false
            //            }
            
            //            if timingInMillis[a].startTime > time && timingInMillis[a].startTime < time {
            //                isValid = false
            //                brea
            
            //            else{
            //                isValid = true
            //            }
        }
        
        
        
        //        if timingInMillis[timingInMillis.count-1].startTime != 0 && timingInMillis[timingInMillis.count-1].endTime != 0{
        //            addMoreBtn.isHidden = false
        //        }else{
        //            addMoreBtn.isHidden = true
        //        }
        
        //        if isEndValue{
        //            timingInMillis[index].endTime = 0
        //            timingArray[index].endTime = ""
        //            timeSlotTableView.reloadData()
        //        }
        
        if isValid{
            return true
        }else{
            Progress.instance.displayAlert(userMessage:Validation.call.enterValidTime)
            return false
        }
        
    }
    
    func seeAppointmentOfSelectedDate(date:String){
        
        timingInMillis.removeAll()
        timingArray.removeAll()
        if date == convertToLocalOnlyDate(utcDate: Date()){
            pickerViewTime.minimumDate = Date()
        }else{
            pickerViewTime.minimumDate = nil
        }
        
        APIManager.sharedInstance.seeAppointmentsAPI(date: date) { (response) in
            self.modelObj = response
            self.timingArray.removeAll()
            for appointment in self.modelObj.appointmentList! {
                self.timingArray.append(ScheduleTiming(startTime: self.conversion24hrFormatTo12hrFormatWithSec(dateStr:appointment.startTime!), endTime: self.conversion24hrFormatTo12hrFormatWithSec(dateStr:appointment.closeTime!), appointmentTimeId: appointment.appointmentTimeId, status: appointment.status))
                
                let startValue = self.isNullCheck(text: self.conversion24hrFormatTo12hrFormatWithSec(dateStr:appointment.startTime!)) ?  self.convertTimeToDate(time: self.conversion24hrFormatTo12hrFormatWithSec(dateStr:appointment.startTime!)).millisecondsSince1970 : 0
                
                let endValue = self.isNullCheck(text: self.conversion24hrFormatTo12hrFormatWithSec(dateStr:appointment.closeTime!)) ?  self.convertTimeToDate(time: self.conversion24hrFormatTo12hrFormatWithSec(dateStr:appointment.closeTime!)).millisecondsSince1970 : 0
                
                self.timingInMillis.append(ScheduleTimingInMillies(startTime: startValue, endTime: endValue))
            }
            // self.tableViewHeight.constant = 45
            
            if self.timingArray.count>0{
                self.addMoreBtn.isHidden = false
                self.tableViewHeight.constant = CGFloat(45 * self.timingArray.count)
                self.view.layoutIfNeeded()
            }else{
                self.timingArray.append(ScheduleTiming(startTime: "", endTime: "", appointmentTimeId: 0, status: ""))
                self.timingInMillis.append(ScheduleTimingInMillies(startTime: 0, endTime: 0))
                self.tableViewHeight.constant = 45
                self.addMoreBtn.isHidden = true
                
            }
            self.timeSlotTableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setCalendar(){
        
        calendar.calendarWeekdayView.backgroundColor = GreyColor
        calendar.appearance.selectionColor = GreenColor
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.clipsToBounds = true
        calendar.appearance.weekdayFont = UIFont(name: "Avenir", size: 10)
        calendar.appearance.eventDefaultColor = GreenColor
        calendar.appearance.titleFont = UIFont(name: "Avenir", size: 10)
        calendar.appearance.caseOptions = [.weekdayUsesUpperCase]
    }
    
    
    @objc func selectTime(_ sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        timingStr = dateFormatter.string(from: sender.date)
        
    }
    
    func timingValidation(){
        
    }
    
    
    @objc func deleteDateBtnSelected(sender:UIButton){
        
        if timingArray[sender.tag].appointmentTimeId != 0{
            
            
            deleteApi(appointmentId: timingArray[sender.tag].appointmentTimeId,index: sender.tag)
            
        }else{
            timingArray.remove(at: sender.tag)
            timingInMillis.remove(at: sender.tag)
        }
        
        timeSlotTableView.reloadData()
    }
    
    func deleteApi(appointmentId:Int,index:Int){
        APIManager.sharedInstance.deleteTimingsAPI(appointmentId: appointmentId){ (response) in
            self.timingArray.remove(at: index)
            self.timingInMillis.remove(at: index)
            self.timeSlotTableView.reloadData()
        }
    }
    
    @IBAction func addMoreBtnAction(_ sender: UIButton) {
        //        tableCount = tableCount + 1
        timingArray.append(ScheduleTiming(startTime: "", endTime: "", appointmentTimeId: 0, status: ""))
        timingInMillis.append(ScheduleTimingInMillies(startTime: 0, endTime: 0))
        tableViewHeight.constant = CGFloat(45 * timingArray.count)
        timeSlotTableView.reloadData()
        scrollToBottom()
        addMoreBtn.isHidden = true
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.timingArray.count-1, section: 0)
            self.timeSlotTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
        APIManager.sharedInstance.addTimeServicesAPI(servicesData: timingArray,date:calendarSelectedDate){ (response) in
            Progress.instance.displayAlert(userMessage: response.message!)
        }
    }
    
}



extension ScheduleVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeSlotCell") as! timeSlotCell
        cell.fromTimeTxt.inputView = pickerViewTime
        cell.toTimeTxt.inputView = pickerViewTime
        cell.fromTimeTxt.tag = indexPath.row
        cell.toTimeTxt.tag = indexPath.row
        cell.fromTimeTxt.text = timingArray[indexPath.row].startTime //?? ""
        cell.toTimeTxt.text = timingArray[indexPath.row].endTime //?? ""
        
        //        if (cell.fromTimeTxt.text?.count)! > 0{
        //            cell.fromTimeTxt.isUserInteractionEnabled = false
        //        }else{
        //            cell.fromTimeTxt.isUserInteractionEnabled = true
        //        }
        //
        //        if (cell.toTimeTxt.text?.count)! > 0{
        //            cell.toTimeTxt.isUserInteractionEnabled = false
        //        }else{
        //            cell.toTimeTxt.isUserInteractionEnabled = true
        //        }
        
        if timingArray.count == indexPath.row + 1 {
            //            if (cell.fromTimeTxt.text?.count)! > 0{
            //                cell.fromTimeTxt.isUserInteractionEnabled = false
            //            }else{
            //                cell.fromTimeTxt.isUserInteractionEnabled = true
            //            }
            //
            //            if (cell.toTimeTxt.text?.count)! > 0{
            //                cell.toTimeTxt.isUserInteractionEnabled = false
            //            }else{
            //                cell.toTimeTxt.isUserInteractionEnabled = true
            //            }
            
            //
            cell.fromTimeTxt.isUserInteractionEnabled = true
            cell.toTimeTxt.isUserInteractionEnabled = true
        }else {
            cell.fromTimeTxt.isUserInteractionEnabled = false
            cell.toTimeTxt.isUserInteractionEnabled = false
        }
        
        
        
        if timingArray.count == 1 {
            cell.deleteBtn.isHidden = true
            cell.crossBtnWidthConstant.constant = 0
        }else{
            cell.deleteBtn.isHidden = false
            cell.crossBtnWidthConstant.constant = 25
        }
        
        if timingArray[indexPath.row].status! == "B"{
            cell.deleteBtn.isHidden = true
            cell.crossBtnWidthConstant.constant = 0
        }else{
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.addTarget(self, action: #selector(deleteDateBtnSelected(sender:)), for: .touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            cell.crossBtnWidthConstant.constant = 25
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
}


extension ScheduleVC :  FSCalendarDataSource {
    // MARK:- FSCalendarDataSource
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        lblMonth.text = mnthsName[month-1]
        let year = Calendar.current.component(.year, from: currentPageDate)
        lblYear.text = String(year)
    }
}
extension ScheduleVC :  FSCalendarDelegate {
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        //self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        calendarSelectedDate = convertToLocalOnlyDate(utcDate: date)
        seeAppointmentOfSelectedDate(date: calendarSelectedDate)
        //        if calendarSelectedDate.count > 0 && calendarSelectedDate == convertToLocalOnlyDate(utcDate: Date()){
        //            pickerViewTime.minimumDate = Date()
        //        }
        return monthPosition == .current
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
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

class timeSlotCell : UITableViewCell{
    
    @IBOutlet weak var fromTimeTxt: UITextField!
    @IBOutlet weak var toTimeTxt: UITextField!
    @IBOutlet weak var crossBtnWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var addMoreBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
}



