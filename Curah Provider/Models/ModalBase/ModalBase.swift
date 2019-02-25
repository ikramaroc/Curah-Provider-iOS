//
//  ModalBase.swift
//  UnitedCabs
//
//  Created by netset on 8/7/18.
//  Copyright © 2018 netset. All rights reserved.
//

import Foundation
import ObjectMapper

struct ModalBase : Mappable {
    var message : String?
    var status : Int?
    var userInfo : UserInfo?
    var services : [Services]?
    
    //My Review List
    var myReviews : [MyReviews]?
    var imgUrl : String?
    var url : String?
    
    var connection_id: Int?

    
    // Home Screen (Pending Appointments)
    var appointments : [Appointments]?
    var inProcessService : Appointments?
    
    // Portfolio list
    var portfolioList : [PortfolioList]?
    
    // Customer Appointments
    var customerAppointments : [CustomerAppointments]?
    
    
    // Appointment Details
    var appointmentDetails : CustomerAppointments?
    var rating : Rating?
    
    // Messages List
    var connections : [Connections]?
    //One to one message conversations
    var conversations :  [conversations]?
    
    
    //History List
    var historyList : [Appointments]?
    
    // send message
    var sendLastMsg : conversations?
    
    var documents : [documents]?
    
    //Appointments
    var providerAppointment : [ProviderAppointment]?
    
    var notifications : [notifications]?

    var appointmentList : [AppointmentList]?
    
    var bankDetails : BankDetails!
    
    
    init?(map:Map) {
        
    }
    
    mutating func mapping(map:Map) {
        message <- map["message"]
        status <- map["status"]
        userInfo <- map["userInfo"]
        services <- map["services"]
        bankDetails <- map["bankDetails"]
        //My Review List
        myReviews <- map["my_reviews"]
        imgUrl <- map["img_url"]
        
         // Home Screen (Pending Appointments)
        appointments <- map["provider_appointment"]
        inProcessService <- map["inprocessService"]
        
        portfolioList <- map["porfolio"]
        url <- map["url"]
        
        connection_id <- map["connection_id"]

        
        // Appointment Details
        appointmentDetails <- map["appointmentDetails"]
        rating <- map["rating"]
        
        // Messages List
        connections <- map["connections"]
        //One to one message conversations
        conversations <- map["conversations"]
        
        //history list
        historyList <- map["history"]
        
        sendLastMsg <- map["last_msg"]
        documents <- map["documents"]
        
        // Customer Appointments
        customerAppointments <- map["customerAppointments"]
        
        // Appointments
        
        providerAppointment <- map["provider_appointment"]
        
        notifications <- map["notifications"]
        appointmentList <- map["data"]
    }
}

struct BankDetails :Mappable{
    var code: String!
    var user_id: Int!
    var dashboard_link : String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        user_id <- map["user_id"]
        dashboard_link <- map["dashboard_link"]
    }
}


struct UserInfo : Mappable {
    var id : Int?
    var token : String?
    var firstname : String?
    var lastname : String?
    var dob : String?
    var city : String?
    var state : String?
    var mobile : String?
    var fbLink : String?
    var instaLink : String?
    var yelpLink : String?
    var rating : String?
    var reviewCount : Int?
    var profileImageUrl : URL?
    var profileImageUrlApi : String?
    var experience : String?
    var address : String?
    var imgUrl : String?
    var appointment_from : String?
    var licenseNumber : String?
    var appointment_to : String?
    var latitude : String?
    var longitude : String?
    var license : String?
    var identification_card : String?
    var profileImage : String?
    var notificationType : String?
      var phone : String?
    // user own
    
    
    var userImage : UIImage?
    var drivingLicenseImage : UIImage = #imageLiteral(resourceName: "profile")
    var identificationCardImage : UIImage = #imageLiteral(resourceName: "profile")
    var location : String?
    var workingHrsTo : String?
    var workingHrsFrom : String?
    var breakHrsTo : String?
    var breakHrsFrom : String?
    
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        dob <- map["dob"]
        state <- map["state"]
        city <- map["city"]
        rating <- map["rating"]
        reviewCount <- map["reviewCount"]
        token <- map["token"]
        id <- map["id"]
        profileImageUrlApi <- map["imgUrl"]
        address <- map["address"]
        dob <- map["dob"]
        profileImage <- map["profile_image"]
        city <- map["city"]
        rating <- map["rating"]
        reviewCount <- map["reviewCount"]
        imgUrl <- map["imgUrl"]
        fbLink <- map["facebook_link"]
        instaLink <- map["instagram_link"]
        yelpLink <- map["yelp_link"]
        appointment_from <- map["appointment_from"]
        appointment_to <- map["appointment_to"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        experience <- map["experience"]
        license <- map["license"]
        identification_card <- map["identification_card"]
        notificationType <- map["notification_type"]
        phone <- map["phone"]
        licenseNumber <- map["license_number"]
        breakHrsTo <- map["breaktime_to"]
        breakHrsFrom <- map["breaktime_from"]
    }
}

struct CustomerAppointments : Mappable {
    var bookingId : Int?
    var price : Int?
    var status : String?
    var userId : Int?
    var serviceName : String?
    var date : String?
    var cancelDescription : String?
    var cancelBy : String?
    var getPrice : Double?
    var providerId : Int?
    var address : String?
    var description : String?
    var startTime : String?
    var closeTime : String?
    var serviceNameArr : [Keywords]?
    var userDetails : User_details?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        bookingId <- map["booking_id"]
        price <- map["price"]
        status <- map["status"]
        userId <- map["user_id"]
        serviceName <- map["service_name"]
        date <- map["date"]
        cancelDescription <- map["cancel_description"]
        cancelBy <- map["cancel_by"]
        getPrice <- map["getPrice"]
        providerId <- map["provider_id"]
        address <- map["address"]
        description <- map["description"]
        startTime <- map["start_time"]
        closeTime <- map["close_time"]
        serviceNameArr <- map["service_name"]
        userDetails <- map["user_details"]
    }
}

struct notifications : Mappable {
    var sender_id : Int?
    var receiver_id : Int?
    var notification_id : String?
    var label : String?
    var date : String?
    var type : String?
    var message : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        sender_id <- map["sender_id"]
        receiver_id <- map["receiver_id"]
        notification_id <- map["notification_id"]
        label <- map["label"]
        date <- map["date"]
        type <- map["type"]
        message <- map["message"]
        
    }
}

struct AppointmentList : Mappable {
    var userId : Int?
    var providerId : Int?
    var date : Int?
    var appointmentTimeId : Int?
    var status : String?
    var startTime : String?
    var closeTime : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        userId <- map["user_id"]
        providerId <- map["provider_id"]
        date <- map["date"]
        appointmentTimeId <- map["appointmentTime_id"]
        status <- map["status"]
        startTime <- map["start_time"]
        closeTime <- map["close_time"]
        
    }
}


struct Keywords : Mappable {
    var id : Int?
    var name : String?
    var price : String?
    var priceValue : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
    }
}

struct User_details : Mappable {
    var firstname : String?
    var profileImage : String?
    var phone : String?
    var distance : Int?
    var rating : String?
    var id : Int?
    var connection_id : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        firstname <- map["firstname"]
        profileImage <- map["profile_image"]
        phone <- map["phone"]
        distance <- map["distance"]
        rating <- map["rating"]
        id <- map["id"]
        connection_id <- map["connection_id"]
        
    }
}

struct Rating : Mappable {
    var providerRating : Int?
    var providerMessage : String?
    var customerRating : Int?
    var customerMessage : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        providerRating <- map["provider_rating"]
        providerMessage <- map["provider_message"]
        customerRating <- map["customer_rating"]
        customerMessage <- map["customer_message"]
    }
}


//gobinder
struct documents : Mappable {
    var driving_license : String?
    var identification_card : String?
    var license_number : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        license_number <- map["license_number"]
        driving_license <- map["driving_license"]
        identification_card <- map["identification_card"]
    }
}



//gobinder
struct PortfolioList : Mappable {
    var id : Int?
    var title : String?
    var file : String?
    var description : String?
    var type : String?
    var video_thumb : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        file <- map["file"]
        type <- map["type"]
        description <- map["description"]
        video_thumb <- map["video_thumb"]
    }
}

struct Services : Mappable {
    var name : String?
    var serviceId : Int?
    var selectedServiceId : String?
    var type : String?
    var price : Int?
    var isApproved : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        isApproved <- map["is_approved"]
        serviceId <- map["service_id"]
        type <- map["type"]
        price <- map["price"]
    }
}

struct MyReviews : Mappable {
    var firstname : String?
    var lastname : String?
    var profileImg : String?
    var rating : Int?
    var description : String?
    var username : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        profileImg <- map["profile_image"]
        rating <- map["rating"]
        description <- map["description"]
    }
}


struct Appointments : Mappable {
    var bookingId : Int?
    var providerId : Int?
    var startTime : String?
    var closeTime : String?
    var date : String?
    var status : String?
    var price : Int?
    var customerId : Int?
    var serviceName : String?
   
    var appointmentId : Int?
    var getPrice : String?
    var firstName : String?
    var lastName : String?
    var image : String?
    var address : String?
    var workDescription : String?
    var cancelType : String?
    var cancelDescription : String?
    var rating : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        bookingId <- map["bookingId"]
        bookingId <- map["booking_id"]
        providerId <- map["provider_id"]
        startTime <- map["start_time"]
        closeTime <- map["close_time"]
        date <- map["date"]
        getPrice <- map["getPrice"]
        status <- map["status"]
        price <- map["price"]
        customerId <- map["customer_id"]
        serviceName <- map["service_name"]
        appointmentId <- map["appointment_id"]
        firstName <- map["firstname"]
        lastName <- map["lastname"]
        image <- map["image"]
        address <- map["address"]
        workDescription <- map["work_description"]
        cancelType <- map["cancel_type"]
        cancelDescription <- map["cancel_description"]
        rating <- map["rating"]
    }
}


struct conversations : Mappable {
    var userId : Int?
    var userName : String?
    var lastmessage : String?
    var userImage : String?
    var messageImage : String?
    var time : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        userId <- map["user_id"]
        userName <- map["user_name"]
        lastmessage <- map["message"]
        userImage <- map["user_image"]
        messageImage <- map["image"]
        time <- map["time"]
    }
}


struct Connections : Mappable {
    var connectionId : Int?
    var userId : Int?
    var userName : String?
    var lastmessage : String?
    var userImage : String?
    var time : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        connectionId <- map["connection_id"]
        userId <- map["user_id"]
        userName <- map["user_name"]
        lastmessage <- map["lastmessage"]
        userImage <- map["user_image"]
        time <- map["time"]
    }
}


struct ProviderAppointment : Mappable {
    var bookingId : Int?
    var provider_id : Int?
    var start_time : String?
    var close_time : String?
    var date : String?
    var status : String?
    var price : String?
    var customer_id : Int?
    var cancel_by : String?
    var cancel_description : String?
    var service_name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        bookingId <- map["bookingId"]
        provider_id <- map["provider_id"]
        start_time <- map["start_time"]
        close_time <- map["close_time"]
        date <- map["date"]
        status <- map["status"]
        price <- map["price"]
        customer_id <- map["customer_id"]
        cancel_by <- map["cancel_by"]
        cancel_description <- map["cancel_description"]
        service_name <- map["service_name"]
    }
    
}
