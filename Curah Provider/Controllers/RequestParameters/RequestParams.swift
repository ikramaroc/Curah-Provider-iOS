//
//  RequestParams.swift
//  Shopaves
//
//  Created by Shopaves on 20/04/18.
//  Created by Shopaves. All rights reserved.
//

import Foundation

//Sign up Params
enum Param : String {
    
    // MARK:- create account
    case email = "email"
    case password = "password"
    case registerType = "register_type"
    case socialId = "social_id"
    case facebook = "F"
    case google = "G"
    case others = "O"
    case authToken = "token"
    case contentType = "application/json"
    case contentTypeTitle = "Content-Type"
    case appType = "apptype"
    // ****************
    
    
    // MARK:-  login
    case deviceId = "device_id"
    case profileId = "profile_id"
    case userType = "user_type"
    case serviceProvider = "S"
    case customer = "C"
    case deviceType = "device_type"
    case ios = "I"

    // ****************
    
    
    // MARK:-  Create Profile
    case firstName = "firstname"
    case lastName = "lastname"
    case profileImage = "profile_image"
    case drivingLicenseImage = "driving_license"
    case identificationCardImage = "identification_card"
    case user = "user_id"
    case phone = "phone"
    
    case oldPassword = "old_password"
    case newPassword = "new_password"
    
    case licenseNumber = "license_number"
    case fbLink = "fb_link"
    case instLink = "ins_link"
    case yelpLink = "yelp_link"
    case address = "address"
    case workingFrom = "appointment_from"
    case workingTo = "appointment_to"
    case experience = "experience"
    case userProviderId = "provider_id"
    case latitude = "latitude"
    case longitude = "longitude"
    case date = "date"
    case serviceId = "service_id"
    case appointmentId = "appointmentTime_id"
    
    
    // ****************
    
    
    // MARK:-  Create Profile
    case services = "services"
    case id = "id"
    case name = "name"
    case price = "price"
    // ****************
    
    
    // MARK:-  Bank Account Details
    case bankName = "bankName"
    case routingNumber = "routingNumber"
    case accountNumber = "accountNumber"
     case postalcode = "postalcode"
    // ****************
    
    
    
    // MARK:-  Notifications
    case notificationStatus = "type"
    case on = "ON"
    case off = "OFF"
    // ****************
    
    
    // MARK:-  Contact Us
    case subject = "subject"
    case message = "message"
    // ****************
    
    
    // MARK:-  Appointment Status
    case bookingId = "booking_id"
    case status = "status"
    case cancelDesc = "cancel_description"
    case accept = "A"
    case reject = "R"
    case reasonForCancel = "Service Provider have not accept the request."
    case busyWithOtherTask = "Busy with other task."
    // ****************
    
    // MARK:-  Delete connections in messages
    
    case connectionId = "connection_id"
    case receiverId = "receiver_id"
    case senderId = "sender_id"
    case image = "image"

    // ****************
    
    
    // MARK:-  Add Portfolio
    case file = "file"
    case title = "title"
    case description = "description"
    case video_thumb = "video_thumb"
    // ****************
    
    
    case portfolioId = "portfolio_id"
    case times = "times"

    //Rating
    case raterId = "rater_id"
    case ratableId = "ratable_id"
    case rating = "rating"  
    
    case auth = "Authorization"
    case appVersion = "version"
    case deviceTypeName = "IOS"
    
    case venue = "venue"
    case favoIds = "favoriteIds"

    // Verify Account
    case code = "verificationCode"
    case gender = "gender"
    case anonymous = "anonymous"
    case countryCode = "countryCode"
    case userAuth = "userAuth"
    case username = "username"
    
    case city = "city"
    case state = "state"
    case breakFrom = "breaktime_from"
    case breakTo = "breaktime_to"
    case country = "country"
    case zipCode = "zipCode"
    case shippingAddresss = "shippingAddresss"
    case userPreference = "userPreference"
    case cities = "cities"
    case colors = "colors"
    case brands = "brands"
    case styles = "styles"
    case tags = "tags"
    case categories = "categories"
    case socialAccounts = "socialAccounts"
    case appId = "appId"
    case startTime = "start_time"
    case endTime = "close_time"
    
    case startService = "Start Service"
    case endService = "End Service"
    
}


enum BookingStatus : String {
    // STATUS
    case accept = "A"
    case reject = "R"
    case inProgress = "I"
    case cancelled = "K"
    case waiting = "P"
    case completed = "C"
    case ended = "E"
    case start = "S"
}

enum segueId : String {
    case createProfile = "segueCreateProfile"
    case loginToCreateProfile = "segueLoginToCreateProfile"
    case createProfileToCompleteProfile = "segueCompleteProfile"
    case completeProfileToAddServices = "segueAddServices"
    case addBankDetail = "segueAddBankDetail"
    case myReviews = "segueReviewList"
   // case completeProfileToAddServices = "segueAddServices"

    case providerList = "segueProviderList"
    case subServices = "segueToHair"
    case subServicesOthers = "segueToOtherServices"
    
    case editProfile = "editProfileSegue"
    case myCards = "segueMyCardsVC"
    case detail = "segueDetailVC"
    case cancelAppointment = "segueCancelAppointmentVC"
    
    
    
    
    
}


