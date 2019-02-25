//
//  Constant.swift
//  WalFly
//
//  Created by Ranjana Prashar on 4/10/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import Foundation
import UIKit
internal struct Constants{
    private enum BaseUrl : String {
        case live = "https://curahapp.com/webservice/"
        // case local = "http://192.168.2.252/curah/webservice/"
        case local = "http://192.168.2.39/allproject/curah/webservice/"
    }
    
    struct Color {
        static let k_deleteBackgroundColor: UIColor = UIColor(red: 247.0/255.0, green: 0.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        static let k_PinkColor: UIColor = UIColor(red: 198.0/255.0, green: 150.0/255.0, blue: 174.0/255.0, alpha: 1.0)
    }
    
    struct APIConstantNames {
        static let baseUrl = BaseUrl.live.rawValue
        static let version = ""
        static let login = APIConstantNames.baseUrl + "login"
        static let forgotPassword = APIConstantNames.baseUrl + "forgotPassword"
        static let signUp = APIConstantNames.baseUrl + "createAccount"
        static let createProfile = APIConstantNames.baseUrl + "createProfile"
        static let getSuggestedServices = APIConstantNames.baseUrl + "suggestedServices"
        static let addServices = APIConstantNames.baseUrl + "addService"
        static let getServices = APIConstantNames.baseUrl + "getServices"
        static let addBank = APIConstantNames.baseUrl + "addBank"
        static let changeNotification = APIConstantNames.baseUrl + "changeNotification"
        static let getReviewList = APIConstantNames.baseUrl + "myReviews"
        static let contactUs = APIConstantNames.baseUrl + "contactUs"
         static let changePassword = APIConstantNames.baseUrl + "changePassword"
        static let newAppointments = APIConstantNames.baseUrl + "newAppointments"
        static let acceptRejectAppointments = APIConstantNames.baseUrl + "acceptRejectAppointments"
        static let cancelAppointment = APIConstantNames.baseUrl + "cancelAppointment"
        static let startService = APIConstantNames.baseUrl + "startService"
        static let cancelService = APIConstantNames.baseUrl + "cancelService"
        static let endService = APIConstantNames.baseUrl + "endService"
        static let deleteUserServices = APIConstantNames.baseUrl + "deleteUserServices"
        static let updateUserServices = APIConstantNames.baseUrl + "updateUserServices"
        static let getMessages = APIConstantNames.baseUrl + "messages"
        static let deleteUserInMessages = APIConstantNames.baseUrl + "deleteConnections"
        static let getOneToOneMessagesList = APIConstantNames.baseUrl + "getConversations"
        static let sendMessage = APIConstantNames.baseUrl + "sendMessage"
        static let addPortfolio = APIConstantNames.baseUrl + "addPortfolio"
        static let getPortfolioList = APIConstantNames.baseUrl + "viewPortfolio"
        static let deletePortfolio = APIConstantNames.baseUrl + "deletePortfolio"
        static let editPortfolio = APIConstantNames.baseUrl + "editPortfolio"
        static let getHistoryList = APIConstantNames.baseUrl + "history"
        static let editMyDocument = APIConstantNames.baseUrl + "editMyDocument"
        static let getAppointments = APIConstantNames.baseUrl + "providerAppointments"
        static let appointmentDetail = APIConstantNames.baseUrl + "appointmentDetail"
        static let getNotification = APIConstantNames.baseUrl + "getNotification"
        static let addTimeForAppointment = APIConstantNames.baseUrl + "addTimeForAppointment"
        static let seeAppointment = APIConstantNames.baseUrl + "seeAppointment"
        static let deleteAppointment = APIConstantNames.baseUrl + "deleteAppointment"
        static let rateUser = APIConstantNames.baseUrl + "rating"
        static let showServices = APIConstantNames.baseUrl + "showServices"
        
        
        
        //7.delete user services (deleteUserServices) screen- 56
    }
    
    struct appColor {
        static let appColorMainGreen : UIColor = UIColor(red: 198.0/255.0, green: 213.0/255.0, blue: 150.0/255.0, alpha: 1)
        static let appColorMainPurple : UIColor = UIColor(red: 90.0/255.0, green: 30.0/255.0, blue: 85.0/255.0, alpha: 1)
    }
    
    //MARK:- FONTS USED IN APP:--
    struct AppFont{
        static let fontHeavy = "AvenirLTStd-Heavy"
        static let fontRoman = "AvenirLTStd-Roman"
        static let fontAvenirRoman = "Avenir-Roman"
        static let fontAvenirBook = "Avenir-Book"
        static let fontAvenirHeavy = "Avenir-Heavy"
        static let fontAvenirMedium = "Avenir-Medium"
    }
    
    struct App {
        static let name = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }
}
