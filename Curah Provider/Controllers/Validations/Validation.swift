//
//  Validation.swift
//  Adeeb
//
//  Created by Apple on 09/12/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class Validation: NSObject {
    struct call {
        static let noInternet = "Internet connection seems to be offline"
        
        // Login
        static let enterEmail = "Please enter email address"
        static let validEmail = "Please enter a valid email address"
        static let enterPassword = "Please enter password"
        static let enterConfirmPassword = "Please enter confirm password"
        static let enterOldPassword = "Please enter old password"
        static let enterNewPassword = "Please enter new password"
        static let passwordNotMatch = "Password not match"
        static let passwordLimit = "Password must be at least 8 characters"
        static let acceptTermsPrivacy = "Please accept Privacy Policy & Terms of Service"

        static let selectGender = "Please select gender"

        // Forgot Password
        static let registeredEmail = "Please enter your registered email address"
        
        // SignUp
        static let userName = "Please enter user name"
        static let firstName = "Please enter first name"
        static let lastName = "Please enter last name"
        static let phone = "Please enter phone address"
        static let facebook = "Please enter facebook link"
        static let insta = "Please enter instagram link"
        static let facebookValid = "Please enter valid facebook link"
        static let instaValid = "Please enter valid instagram link"
        static let dob = "Please enter date of birth"
        
        static let uploadDrivingLicense = "Please upload cosmetology license picture"
        static let profilePhoto = "Please upload profile picture"
        static let oneHourSlot = "Please select one hour slot"

        static let uploadIdentificationCard = "Please upload identification card picture"
        static let enterExperience = "Please enter your experience"
        static let enterLocation = "Please enter your location"
        static let enterCity = "Please enter your city"
        static let workingHrs = "Please enter working hours"
        static let breakHrs = "Please enter break hours"
        static let provideRating = "Please provide rating"
        static let enterDescriptionText = "Please enter description"
        static let noPhotoDR = "Please upload cosmetology license"
        static let noPhotoID = "Please upload identification card"

        
        // Add Service
        static let minService = "Please enter atleast 1 service on order to proceed"
        // Add Bank Account Details
        static let enterYourName        = "Please enter your name"
        static let enterAccountNumber   = "Please enter account number"
        static let enterPhoneNumber   = "Please enter phone number"
        static let enterBankAddress   = "Please enter bank address"
        static let enterValidAccountNumber   = "Please enter valid account number"
        static let enterBranchName      = "Please enter branch name"
        static let enterBankName        = "Please enter bank name"
        static let enterRoutingNumber   = "Please enter routing number"
        static let enterValidRoutingNumber   = "Please enter valid routing number"
        
        static let enterSubject   = "Please enter subject"
        static let entermessage   = "Please enter message"
        
        static let facebookLinkNotAvailable = "Facebook link is not provided"
        static let instagramLinkNotAvailable = "Instagram link is not provided"
        
        // Add portfolio
        static let enterTitle = "Please enter title"
        static let enterDescription = "Please enter description"
        static let enterType = "Please select image or video"
        
        // Delete services
        static let deleteServices = "You should have alteast one predefined service from the suggestion list."
        
        // Schedule
        static let enterValidTime = "Please enter valid time"
        static let enterCalendarTime = "Please select date first"
        static let enterStartTime = "Please select start date first"

        
        
    }
    
    struct row {
        static let height = 70.0
    }
    
    struct notificationRow {
        static let ipadHeight = 90.0
        static let height = 60.0
    }
    
    struct headerHeight {
        static let iphone = 40.0
        static let ipad = 60.0
    }
}
