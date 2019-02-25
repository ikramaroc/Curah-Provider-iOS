//
//  RateReviewPopUpVC.swift
//  QurahApp
//
//  Created by netset on 7/23/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import FloatRatingView

protocol  reloadServiceDataProtocol {
    func reloadData()
}

class RateReviewPopUpVC: UIViewController {
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var reviewTxtView: KMPlaceholderTextView!
    var otherUserId = Int()
    var bookingId = Int()
    var delegate : reloadServiceDataProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validation(){
        
        if reviewTxtView.text.count == 0{
             Progress.instance.displayAlert(userMessage:Validation.call.enterDescriptionText)
        }else{
            self.submitRatingApi()
        }
        
    }
    
    func submitRatingApi(){
        APIManager.sharedInstance.giveRatingAPI(otherUserId: otherUserId, bookingId: bookingId, ratingValue: Int(ratingView.rating), description: reviewTxtView.text!) { (response) in
            Progress.instance.displayAlert(userMessage: response.message!)
            self.delegate.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancelAct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitAct(_ sender: Any) {
        validation()
       
    }
}
