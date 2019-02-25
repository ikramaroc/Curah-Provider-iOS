//
//  ExtraExtensions.swift
//  Curah Provider
//
//  Created by Netset on 19/09/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension UIViewController
{
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func getDeviceToken() -> String  {
        
        if (UserDefaults.standard.value(forKey: "device_token") != nil){
            return UserDefaults.standard.value(forKey: "device_token") as? String ?? ""
        }else{
            return "simulator"
        }
       
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 5) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    func convertToLocalDateFormatOnlyTimeToDate(utcDate:String) -> Date
    {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dt = dateFormatter.date(from: utcDate)
        return dt!
    }
    func convertToLocalDateFormatOnlyTimeToDateString(utcDate:Date) -> String
    {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
      
        return dateFormatter.string(from: utcDate)
    }
    
    func convertDateToString(utcDate:Date) -> String
    {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: utcDate)
    }
    
    func convertToDDMMYYYDateFormat(utcDate:String) -> String
    {
        if utcDate.count == 0
        {
            return ""
        }
        else
        {
        
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dt = dateFormatter.date(from: utcDate)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from:dt!)
        }
    }
    func convertTimeToDate(time:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
//        dateFormatter.timeZone =    TimeZone(secondsFromGMT: 0)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.date(from: time)!
        
    }
    
    
    func convertTimeToDateFormat(time:Date) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let str = dateFormatter.string(from: time)
        
        return dateFormatter.date(from: str)!
        
    }
    func convertTimeToDateFormatString(time:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: time)
    }
}
extension Double {
    // Rounds the double to 'places' significant digits
    func roundTo(places:Int) -> Double {
        guard self != 0.0 else {
            return 0
        }
        let divisor = pow(10.0, Double(places) - ceil(log10(fabs(self))))
        return (self * divisor).rounded() / divisor
    }
}

extension UIDatePicker {
    func set13YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -13
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -100
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
    
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: Constants.AppFont.fontAvenirHeavy, size: 15)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: Constants.AppFont.fontAvenirRoman, size: 14)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
}

extension String {
    func validateUrl () -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension UILabel {
    func setHTML(html: String) {
        do {
            let at : NSAttributedString = try NSAttributedString(data: html.data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil);
            self.attributedText = at;
        } catch {
            self.text = html;
        }
    }
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.underlineStyle, value:NSUnderlineStyle.styleSingle.rawValue , range: NSRange(location: 0, length: attributedString.length - 1))
            
            attributedText = attributedString
        }
    }
}
