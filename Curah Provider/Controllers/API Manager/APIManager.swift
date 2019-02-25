//
//  APIManager.swift
//  Curah
//
//  Created by netset on 8/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import CoreLocation
import ObjectMapper
import AlamofireObjectMapper

class APIManager: NSObject {
    
    typealias Response = (ModalBase) -> Void
    static let sharedInstance = APIManager()
    let locale = String(Locale.current.identifier)
    
    func headers() ->  [String:String] {
        var appVersion = String()
        var token : String = ""
        if let info = Bundle.main.infoDictionary {
            appVersion = info["CFBundleShortVersionString"] as? String ?? "1.0"
        }
        if ModalShareInstance.shareInstance.modalUserData != nil {
            token = (ModalShareInstance.shareInstance.modalUserData.userInfo?.token!)!
        }
        let headers = [
            Param.appVersion.rawValue : appVersion,
            Param.authToken.rawValue : token,
            Param.contentTypeTitle.rawValue : Param.contentType.rawValue,
            Param.notificationStatus.rawValue : Param.ios.rawValue,
            Param.appType.rawValue : Param.serviceProvider.rawValue]
        print(headers)
        return headers
    }
    
    // MARK:- *********************** Login API ***********************
    func loginAPI(email:String,password:String,token:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.login)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            
            let params : Dictionary = [Param.email.rawValue:email, Param.password.rawValue:password, Param.deviceId.rawValue:token, Param.userType.rawValue:Param.serviceProvider.rawValue,Param.deviceType.rawValue:Param.ios.rawValue,Param.latitude.rawValue:loc.coordinate.latitude,Param.longitude.rawValue:loc.coordinate.longitude] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                print(JSON)
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Forgot Password API ***********************
    func forgotPasswordAPI(email:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.forgotPassword)"
            print(url)
            let params : Dictionary = [Param.email.rawValue:email] as [String : String]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Get Suggested Services API (suggestedServices screen - 20) ***********************
    func getSuggestedServicesAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getSuggestedServices)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Update Services API (suggestedServices screen - 20) ***********************
    func updateServicesAPI(serviceId:Int,price:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.updateUserServices)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.serviceId.rawValue:serviceId,Param.price.rawValue:price] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Delete Services API (suggestedServices screen - 20) ***********************
    func deleteServicesAPI(serviceId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.deleteUserServices)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.serviceId.rawValue:serviceId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Get user Services API (suggestedServices screen - 20) ***********************
    func getUserServicesAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getServices)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** See apointments of selected date ***********************
    func seeAppointmentsAPI(date:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.seeAppointment)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.date.rawValue:date,Param.userProviderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Delete timings of selected date ***********************
    func deleteTimingsAPI(appointmentId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.deleteAppointment)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.appointmentId.rawValue:appointmentId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Add Bank Detail API (34. Add Bank (addCard) screen 13) ***********************
    func addBankDetailsAPI(bankName:String, name:String, accountNumber:String, routingNumber:String,phone:String,postalCode:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.addBank)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.bankName.rawValue:bankName,
                                       Param.name.rawValue:name,
                                       Param.accountNumber.rawValue:accountNumber,
                                       Param.routingNumber.rawValue:routingNumber,
                                       Param.postalcode.rawValue:postalCode,
                                       Param.phone.rawValue:phone] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Add Services API ((add service provider expertise)addService ---- Raw data example screen - 56) ***********************
    func addServicesAPI(servicesData:[ServicesData],custom:Bool ,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.addServices)"
            print(url)
            var arrServices = Array<Any>()
            for service in servicesData {
                let dict = [Param.id.rawValue:service.serviceId!,
                            Param.name.rawValue:service.name!,
                            Param.price.rawValue:service.price!] as [String : Any]
                arrServices.append(dict)
            }
            var params = Dictionary<String, Any>()
            if custom{
                params =  [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                           Param.services.rawValue:arrServices] as [String : Any]
            }
            else {
                params =  [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                           Param.services.rawValue:arrServices] as [String : Any]
            }
            
            self.makePOSTRequestRawData(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- Add services provider
    func addTimeServicesAPI(servicesData:[ScheduleTiming],date:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.addTimeForAppointment)"
            print(url)
            var arrServices = Array<Any>()
            let obj = BaseClass()
            for service in servicesData {
                let dict = [Param.startTime.rawValue:obj.conversion12hrFormatTo24hrFormat(dateStr: service.startTime!),
                            Param.endTime.rawValue:obj.conversion12hrFormatTo24hrFormat(dateStr: service.endTime!)] as [String : Any]
                arrServices.append(dict)
            }
            var params = Dictionary<String, Any>()
            
            params =  [Param.userProviderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                       Param.times.rawValue:arrServices,
                       Param.date.rawValue:date] as [String : Any]
            
            self.makePOSTRequestRawData(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Forgot Password API ***********************
    func appointmentDetailAPI(bookingId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.appointmentDetail)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.userType.rawValue:Param.serviceProvider.rawValue,
                                       Param.bookingId.rawValue:bookingId,
                                       Param.latitude.rawValue:loc.coordinate.latitude,
                                       Param.longitude.rawValue:loc.coordinate.longitude] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    //gobinder
    /// MARK:- *********************** Add/Edit portfolio API ***********************
    func addPortfolio(image:UIImage, videoUrl:URL,type:String,title:String,description:String,videoThumb:UIImage,isEditing:Bool,portfolioId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            var url = String()
            if isEditing{
                url =  "\(Constants.APIConstantNames.editPortfolio)"
            }else{
                url =  "\(Constants.APIConstantNames.addPortfolio)"
            }
            
            print(url)
            self.showHud()
            var params = Dictionary<String, Any>()
            
            if type == "image"
            {
                params = [ Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.title.rawValue:title,Param.description.rawValue:description,Param.notificationStatus.rawValue:"I",Param.portfolioId.rawValue:portfolioId] as [String : Any]
            }else{
                params = [ Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.title.rawValue:title,Param.description.rawValue:description,Param.notificationStatus.rawValue:"V",Param.portfolioId.rawValue:portfolioId] as [String : Any]
            }
            
            print(params)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
                
                if type == "image"
                {
                    multipartFormData.append(UIImageJPEGRepresentation(image, 0.35)!, withName:Param.file.rawValue ,fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                }
                else
                {
                    multipartFormData.append(UIImageJPEGRepresentation(videoThumb, 0.35)!, withName:Param.video_thumb.rawValue ,fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                    
                    multipartFormData.append(videoUrl, withName: Param.file.rawValue, fileName: fileName.appending(".mp4"), mimeType: "video/mp4")
                    
                }
                
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: self.headers()) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseObject { (apiResponse: DataResponse<ModalBase>) in
                        if self.handleSuccessResponse(apiResponse: apiResponse) {
                            print(apiResponse.result.value!)
                            response(apiResponse.result.value!)
                        }
                    }
                case .failure(let error):
                    self.hideHud()
                    print("Error in upload: \(error.localizedDescription)")
                    Progress.instance.displayAlert(userMessage:error.localizedDescription)
                }
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    //gobinder
    /// MARK:- *********************** Update portfolio API ***********************
    func updatePortfolio(type:String,title:String,description:String,portfolioId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            let url =  "\(Constants.APIConstantNames.editPortfolio)"
            
            var params = Dictionary<String, Any>()
            
            if type == "image"
            {
                params = [ Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.title.rawValue:title,Param.description.rawValue:description,Param.notificationStatus.rawValue:"I",Param.portfolioId.rawValue:portfolioId] as [String : Any]
            }
            else
            {
                params = [ Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.title.rawValue:title,Param.description.rawValue:description,Param.notificationStatus.rawValue:"V",Param.portfolioId.rawValue:portfolioId] as [String : Any]
            }
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
        
    }
    
    // MARK:- ********************** Notification List API **********************
    func getNotificationList(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getNotification)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.userType.rawValue:Param.serviceProvider.rawValue] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Portfolio List API ***********************
    func getPortfolioList(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getPortfolioList)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** History List API ***********************
    func getHistoryList(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getHistoryList)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.userType.rawValue:Param.serviceProvider.rawValue] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Delete Portfolio API ***********************
    func deletePortfolio(portfolioId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.deletePortfolio)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.portfolioId.rawValue:portfolioId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Start Service API ((screen 64,65)) ***********************
    func startServiceAPI(bookingId: Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.startService)"
            print(url)
            let params : Dictionary = [Param.userProviderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.bookingId.rawValue:bookingId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** End Service API ((screen 64,65)) ***********************
    func endServiceAPI(bookingId: Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.newAppointments)"
            print(url)
            let params : Dictionary = [Param.userProviderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.bookingId.rawValue:bookingId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** New Appointments Appointments API (34. newAppointments (newAppointments) screen 13) ***********************
    func newAppointmentsAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.newAppointments)"
            print(url)
            let params : Dictionary = [Param.userProviderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** New Appointments Appointments API () ***********************
    func acceptRejectAppointmentsAPI(bookingId:Int,status:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.acceptRejectAppointments)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.bookingId.rawValue:bookingId,
                                       Param.status.rawValue:status] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Start Appointments API () ***********************
    func startAppointmentAPI(bookingId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.startService)"
            print(url)
            let params : Dictionary = [Param.userProviderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.bookingId.rawValue:bookingId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** End Appointment API () ***********************
    func endAppointmentAPI(bookingId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.endService)"
            print(url)
            let params : Dictionary = [Param.userProviderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.bookingId.rawValue:bookingId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** New Appointments Appointments API (34. newAppointments (newAppointments) screen 13) ***********************
    func cancelAppointmentsAPI(bookingId:Int,cancelDesc:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.cancelAppointment)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.bookingId.rawValue:bookingId,
                                       Param.userType.rawValue:Param.serviceProvider.rawValue,
                                       Param.cancelDesc.rawValue: cancelDesc] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Change Notification API (33. changeNotification (changeNotification)) ***********************
    func changeNotificationAPI(status:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.changeNotification)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.notificationStatus.rawValue:status] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Review List API ***********************
    func getReviewListAPI(otherUserId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getReviewList)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.profileId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Contact Us API ***********************
    func contactUsAPI(name:String, subject:String, email:String, message:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.contactUs)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.name.rawValue:name,
                                       Param.subject.rawValue:subject,
                                       Param.email.rawValue:email,
                                       Param.message.rawValue:message] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Contact Us API ***********************
    func changePasswordAPI(currentPassword:String, newPassword:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.changePassword)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.oldPassword.rawValue:currentPassword,Param.newPassword.rawValue:newPassword] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Sign Up (Create Account) API ***********************
    func signUpAPI(email:String,password:String,token:String,registerType:String,socialId:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.signUp)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            let params : Dictionary = [Param.email.rawValue:email,
                                       Param.password.rawValue:password,
                                       Param.registerType.rawValue:registerType,
                                       Param.socialId.rawValue:socialId,
                                       Param.deviceId.rawValue:token,
                                       Param.userType.rawValue:Param.serviceProvider.rawValue,
                                       Param.deviceType.rawValue:Param.ios.rawValue,
                                       Param.latitude.rawValue:loc.coordinate.latitude,
                                       Param.longitude.rawValue:loc.coordinate.longitude] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Create Profile API ***********************
    func createProfileAPI(location:CLLocationCoordinate2D,cityStr:String,stateStr: String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            let url =  "\(Constants.APIConstantNames.createProfile)"
            print(url)
            self.showHud()
            let userData = ModalShareInstance.shareInstance.modalUserData?.userInfo
            let createProfile : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                              Param.firstName.rawValue:userData?.firstname! ?? "",
                                              Param.lastName.rawValue:userData?.lastname! ?? "",
                                              Param.phone.rawValue:userData?.mobile! ?? 0,
                                              Param.fbLink.rawValue:userData?.fbLink! ?? "",
                                              Param.instLink.rawValue:userData?.instaLink! ?? "",
                                              Param.yelpLink.rawValue:userData?.yelpLink! ?? ""
                ] as [String : Any]
            
            let createProfile1 : Dictionary = [
                Param.breakFrom.rawValue:userData?.breakHrsFrom! ?? "",
                Param.breakTo.rawValue:userData?.breakHrsTo! ?? ""
                ] as [String : Any]
            
            
            let completeProfile : Dictionary = [Param.experience.rawValue:userData?.experience! ?? "",
                                                Param.address.rawValue:userData?.location! ?? "",
                                                // Param.city.rawValue:userData?.city! ?? "",
                Param.workingTo.rawValue:userData?.workingHrsTo! ?? "",
                Param.workingFrom.rawValue:userData?.workingHrsFrom! ?? "",
                Param.latitude.rawValue:location.latitude ,
                Param.longitude.rawValue :location.longitude,
                Param.city.rawValue:cityStr,
                Param.state.rawValue:stateStr
                ] as [String : Any]
            let params = NSMutableDictionary(dictionary: createProfile)
            params.addEntries(from: completeProfile)
            params.addEntries(from: createProfile1)
            print(params)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
                }
                if userData?.userImage != #imageLiteral(resourceName: "profile") {
                    let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
                    multipartFormData.append(UIImageJPEGRepresentation((userData?.userImage)!, 0.35)!, withName:Param.profileImage.rawValue ,fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                }
                if userData?.drivingLicenseImage != #imageLiteral(resourceName: "profile") {
                    let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
                    multipartFormData.append(UIImageJPEGRepresentation((userData?.drivingLicenseImage)!, 0.35)!, withName:Param.drivingLicenseImage.rawValue ,fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                }
                if userData?.identificationCardImage != #imageLiteral(resourceName: "profile") {
                    let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
                    multipartFormData.append(UIImageJPEGRepresentation((userData?.identificationCardImage)!, 0.35)!, withName:Param.identificationCardImage.rawValue ,fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                }
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: self.headers()) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseObject { (apiResponse: DataResponse<ModalBase>) in
                        if self.handleSuccessResponse(apiResponse: apiResponse) {
                            print(apiResponse.result.value!)
                            response(apiResponse.result.value!)
                        }
                    }
                case .failure(let error):
                    self.hideHud()
                    print("Error in upload: \(error.localizedDescription)")
                    Progress.instance.displayAlert(userMessage:error.localizedDescription)
                }
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Edit Profile API ***********************
    func editProfileAPI(startTime:String,endTime:String,breakStart:String,breakEnd:String,location:CLLocationCoordinate2D,cityStr:String,stateStr:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            let url =  "\(Constants.APIConstantNames.createProfile)"
            print(url)
            self.showHud()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            let userData = ModalShareInstance.shareInstance.modalUserData?.userInfo
            let createProfile : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                              Param.firstName.rawValue:userData?.firstname! ?? "",
                                              Param.lastName.rawValue:userData?.lastname! ?? "",
                                              Param.phone.rawValue:userData?.mobile! ?? 0,
                                              Param.fbLink.rawValue:userData?.fbLink! ?? "",
                                              Param.instLink.rawValue:userData?.instaLink! ?? "",
                                              Param.yelpLink.rawValue:userData?.yelpLink! ?? ""
                ] as [String : Any]
            let completeProfile : Dictionary = [Param.experience.rawValue:userData?.experience! ?? "",
                                                Param.address.rawValue:userData?.location! ?? "",
                                                // Param.city.rawValue:userData?.city! ?? "",
                Param.workingTo.rawValue:startTime ?? "",
                Param.workingFrom.rawValue:endTime ?? "",
                Param.latitude.rawValue:location.latitude ,
                Param.longitude.rawValue :location.longitude,
                Param.city.rawValue:cityStr,
                Param.state.rawValue:stateStr,
                Param.breakFrom.rawValue:breakStart,
                Param.breakTo.rawValue:breakEnd
                ] as [String : Any]
            let params = NSMutableDictionary(dictionary: createProfile)
            params.addEntries(from: completeProfile)
            print(params)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
                }
                if userData?.userImage != #imageLiteral(resourceName: "profile") && userData?.userImage != nil{
                    let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
                    multipartFormData.append(UIImageJPEGRepresentation((userData?.userImage)!, 0.35)!, withName:Param.profileImage.rawValue ,fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                }
                
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: self.headers()) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseObject { (apiResponse: DataResponse<ModalBase>) in
                        if self.handleSuccessResponse(apiResponse: apiResponse) {
                            print(apiResponse.result.value!)
                            response(apiResponse.result.value!)
                        }
                    }
                case .failure(let error):
                    self.hideHud()
                    print("Error in upload: \(error.localizedDescription)")
                    Progress.instance.displayAlert(userMessage:error.localizedDescription)
                }
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    
    
    /// MARK:- *********************** Send Image Message API ***********************
    func sendImageMessageAPI(image:UIImage,receiverId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            let url =  "\(Constants.APIConstantNames.sendMessage)"
            print(url)
            self.showHud()
            let params : Dictionary = [ Param.receiverId.rawValue:receiverId,
                                        Param.senderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                        ] as [String : Any]
            print(params)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
                multipartFormData.append(UIImageJPEGRepresentation(image, 0.35)!, withName:Param.image.rawValue ,fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: self.headers()) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseObject { (apiResponse: DataResponse<ModalBase>) in
                        if self.handleSuccessResponse(apiResponse: apiResponse) {
                            print(apiResponse.result.value!)
                            response(apiResponse.result.value!)
                        }
                    }
                case .failure(let error):
                    self.hideHud()
                    print("Error in upload: \(error.localizedDescription)")
                    Progress.instance.displayAlert(userMessage:error.localizedDescription)
                }
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    /// MARK:- *********************** update documents API ***********************
    func updateDocuments(licenseImage:UIImage,idCardImage:UIImage,licenseNumberStr:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            let url =  "\(Constants.APIConstantNames.editMyDocument)"
            print(url)
            self.showHud()
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.licenseNumber.rawValue:licenseNumberStr] as [String : Any]
            print(params)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
                multipartFormData.append(UIImageJPEGRepresentation(licenseImage, 0.35)!, withName:Param.drivingLicenseImage.rawValue ,fileName: fileName.appending("lic.jpg"), mimeType: "image/jpg")
                
                multipartFormData.append(UIImageJPEGRepresentation(idCardImage, 0.35)!, withName:Param.identificationCardImage.rawValue ,fileName: fileName.appending("idCard.jpg"), mimeType: "image/jpg")
                
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: self.headers()) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseObject { (apiResponse: DataResponse<ModalBase>) in
                        if self.handleSuccessResponse(apiResponse: apiResponse) {
                            print(apiResponse.result.value!)
                            response(apiResponse.result.value!)
                        }
                    }
                case .failure(let error):
                    self.hideHud()
                    print("Error in upload: \(error.localizedDescription)")
                    Progress.instance.displayAlert(userMessage:error.localizedDescription)
                }
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    /// MARK:- *********************** Get Apppointments (providerAppointments screen 63) API ***********************
    
    func getAppointmentsAPI(date:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getAppointments)"
            print(url)
            let params : Dictionary = [Param.userProviderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.date.rawValue:date] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    /// MARK:- *********************** Give rating API ***********************
    func giveRatingAPI(otherUserId:Int,bookingId:Int,ratingValue:Int,description:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.rateUser)"
            print(url)
            let params : Dictionary = [Param.raterId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.ratableId.rawValue:otherUserId, Param.bookingId.rawValue:bookingId, Param.rating.rawValue:ratingValue, Param.description.rawValue:description] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    /// MARK:- *********************** Get bank detail API ***********************
    func getBankAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.addBank)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    //gobinder
    /// MARK:- *********************** Message List  API ***********************
    func getMessagesAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getMessages)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    //gobinder
    /// MARK:- *********************** Message List  API ***********************
    func deleteUserInMessageAPI(connectionId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.deleteUserInMessages)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.connectionId.rawValue:connectionId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    /// MARK:- *********************** Services List  API ***********************
    func getServicesListAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.showServices)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    /// MARK:- *********************** Message List  API ***********************
    func getOneToOneMessagesListAPI(connectionId:Int,receiverId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getOneToOneMessagesList)"
            print(url)
            let params : Dictionary = [Param.senderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.connectionId.rawValue:connectionId,Param.receiverId.rawValue:receiverId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    /// MARK:- *********************** Send Message List  API ***********************
    func sendTextMessage(receiverId:Int,message:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.sendMessage)"
            print(url)
            let params : Dictionary = [Param.senderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.message.rawValue:message,Param.receiverId.rawValue:receiverId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    func makePOSTRequestRawData(urlAPI:String, paramsAPI:Dictionary<String, Any>, response:@escaping Response) {
        Alamofire.request(self.creatingRequest(strUrl: urlAPI, dictParams: paramsAPI, methodName: HTTPMethod.post.rawValue))
            .responseJSON { (response) in
                print(response.result.value)
                
            }
            .responseObject { (apiResponse: DataResponse<ModalBase>) in
                if self.handleSuccessResponse(apiResponse: apiResponse) {
                    //  print(apiResponse.result.value!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        response(apiResponse.result.value!)
                    }
                }
        }
        
    }
    
    func makePOSTRequest(urlAPI:String, paramsAPI:Dictionary<String, Any>, response:@escaping Response) {
        print(paramsAPI)
        Alamofire.request(urlAPI, method: .post, parameters: paramsAPI, encoding: JSONEncoding.default, headers: self.headers())
            .responseJSON { (response) in
                print(response.result.value)
                
            }
            .responseObject { (apiResponse: DataResponse<ModalBase>) in
                if self.handleSuccessResponse(apiResponse: apiResponse) {
                    // print(apiResponse.result.value!)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        response(apiResponse.result.value!)
                    }
                }
        }
        
    }
    
    func handleSuccessResponse(apiResponse:DataResponse<ModalBase>) -> Bool {
        self.hideHud()
        if apiResponse.result.isSuccess {
            if apiResponse.response?.statusCode == 200 {
                if apiResponse.result.value?.status == 200 || apiResponse.result.value?.status == 404 {
                    return true
                } else if apiResponse.result.value?.status == 401 {
                    var topVC = UIApplication.shared.keyWindow?.rootViewController
                    while((topVC!.presentedViewController) != nil){
                        topVC = topVC!.presentedViewController
                    }
                    let actionSheetController = UIAlertController (title: "Session Expired", message: (apiResponse.result.value?.message)!, preferredStyle: UIAlertControllerStyle.alert)
                    //Add Save-Action
                    actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                        UserDefaults.standard.removeObject(forKey: "USERDETAILS")
                        UserDefaults.standard.synchronize()
                        ModalShareInstance.shareInstance.modalUserData = nil
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.makingRoot("initial")
                    }))
                    topVC?.present(actionSheetController, animated: true, completion: nil)
                } else if apiResponse.result.value?.status == 405 {
                    var topVC = UIApplication.shared.keyWindow?.rootViewController
                    while((topVC!.presentedViewController) != nil){
                        topVC = topVC!.presentedViewController
                    }
                    let actionSheetController = UIAlertController (title: "Update Required", message: (apiResponse.result.value?.message)!, preferredStyle: UIAlertControllerStyle.alert)
                    //Add Save-Action
                    actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                        UserDefaults.standard.removeObject(forKey: "USERDETAILS")
                        UserDefaults.standard.synchronize()
                        ModalShareInstance.shareInstance.modalUserData = nil
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.makingRoot("initial")
                        
                        if let url = URL(string: "itms-apps://itunes.apple.com/"),
                            UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.open(url, options: [:]) { (opened) in
                                if(opened){
                                    print("App Store Opened")
                                }
                            }
                        } else {
                            print("Can't Open URL on Simulator")
                        }
                        
                    }))
                    topVC?.present(actionSheetController, animated: true, completion: nil)
                } else {
                    if apiResponse.result.value?.message != nil {
                        Progress.instance.displayAlert(userMessage:(apiResponse.result.value?.message)!)
                    }
                }
            } else {
                Progress.instance.displayAlert(userMessage:(apiResponse.result.value?.message)!)
            }
        } else {
            self.handleFailureResponse(apifailure:apiResponse.result.error!)
        }
        //print(apiResponse)
        return false
    }
    
    func creatingRequest(strUrl:String, dictParams: Dictionary<String, Any>, methodName:String) -> URLRequest {
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = methodName
        request.allHTTPHeaderFields = self.headers()
        let data = try! JSONSerialization.data(withJSONObject: dictParams, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        if methodName !=  HTTPMethod.get.rawValue {
            request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        }
        return request
    }
    
    func handleFailureResponse(apifailure:Error)  {
        print("failure")
        let error : Error = apifailure
        Progress.instance.displayAlert(userMessage:error.localizedDescription)
    }
    
    func showHud() {
        Progress.instance.show()
    }
    
    func hideHud() {
        Progress.instance.hide()
    }
}


extension Date {
    func stringDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
