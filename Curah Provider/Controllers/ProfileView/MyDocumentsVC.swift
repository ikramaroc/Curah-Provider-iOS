//
//  MyDocumentsVC.swift
//  CurahApp
//
//  Created by Netset on 28/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

class MyDocumentsVC: UIViewController {

    @IBOutlet weak var viewIdentification: UIView!
    @IBOutlet weak var viewDrivingLicen: UIView!
    @IBOutlet weak var drivingLicenseImageView: UIImageView!
    @IBOutlet weak var identificationCardImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpData()
    }
    
    func initView(){
     viewDrivingLicen.layer.borderWidth = 1
     viewDrivingLicen.layer.borderColor = UIColor.gray.cgColor
     viewIdentification.layer.borderWidth = 1
     viewIdentification.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setUpData(){
        
        let userData = ModalShareInstance.shareInstance.modalUserData.userInfo
        
        if (userData?.license?.count != 0 && userData?.license != nil ) {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: (drivingLicenseImageView.bounds.size.width)/2, y: (drivingLicenseImageView.bounds.size.height)/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            self.drivingLicenseImageView.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (userData?.imgUrl)! as String + (userData?.license!)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.drivingLicenseImageView.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        
        if (userData?.identification_card?.count != 0 && userData?.identification_card != nil ) {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: (self.identificationCardImageView.bounds.size.width)/2, y: (self.identificationCardImageView.bounds.size.height)/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            self.identificationCardImageView.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (userData?.imgUrl)! as String + (userData?.identification_card!)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.identificationCardImageView.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        
    }
    
    @IBAction func btnEditDocument(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditDocumentVC") as! EditDocumentVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
