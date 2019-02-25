//
//  PortFolioDetailVC.swift
//  CurahApp
//
//  Created by Netset on 27/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import AVKit
import SKPhotoBrowser

protocol reloadDataProtocol {
    func reloadData()
}

class PortFolioDetailVC: UIViewController,reloadDataAfterUpdationProtocol {
 
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleHeaderLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var videoBtn: UIButton!
    
    var delegate:reloadDataProtocol!
    var imageUrl = String()
    var videoUrl = String()
    var titleHeaderStr = String()
    var descriptionStr = String()
    var type =  String()
    var portfolioId =  Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        loadData()
    }
    
    func loadData()
    {
        titleHeaderLbl.text = titleHeaderStr
        descriptionLbl.text = descriptionStr
        
        if (imageUrl.count != 0) {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: (backgroundImageView.bounds.size.width)/2, y: (backgroundImageView.bounds.size.height)/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            backgroundImageView.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: imageUrl, completionHandler:{(image: UIImage?, url: String) in
                self.backgroundImageView.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        
        if type == "image"{
            videoBtn.isHidden = true
        }else{
            videoBtn.isHidden = false
        }
    }
    
    func reloadListData() {
        loadData()
        delegate.reloadData()
    }
    
    func playVideo(strVideo:String) {
        let videoURL = URL(string:strVideo)
        let player = AVPlayer(url: videoURL!)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func playVideoOrViewImageFullScreenBtnAction(_ sender: UIButton) {
        if type == "image"{
//            var images = [SKPhoto]()
//            for index in 0..<1 {
//                let photo = SKPhoto.photoWithImageURL(imageUrl)
//                photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
//                images.append(photo)
//            }
//            
//            let originImage = #imageLiteral(resourceName: "ico_loading") // some image for baseImage
//            let browser = SKPhotoBrowser(originImage: originImage , photos: images, animatedFromView: view)
//            SKPhotoBrowserOptions.displayStatusbar = false                              // all tool bar will be hidden
//            SKPhotoBrowserOptions.displayAction = false                               // action button will be hidden
//            browser.initializePageIndex(0)
//            present(browser, animated: true, completion: {})
            
        }else{
            playVideo(strVideo: videoUrl)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
      
        self.dismiss(animated: false) {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPortfiloVC") as? AddPortfiloVC {
                vc.isEditingPortfolio = true
                vc.dataType = self.type
                vc.descriptionStr = self.descriptionStr
                vc.titleStr = self.titleHeaderStr
                vc.thumbUrl = self.imageUrl
                vc.portfolioId = self.portfolioId
                vc.delegate1 = self
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        let actionSheetController = UIAlertController (title: "Are you sure you want to delete this portfolio ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        //Add Cancel-Action
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        //Add Save-Action
        actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
            self.deletePortfolio()
        }))
        
        let appDelegateObj = UIApplication.shared.delegate as! AppDelegate
        appDelegateObj.window?.rootViewController?.present(actionSheetController, animated: true, completion: nil)
        
        //present actionSheetController
//        present(actionSheetController, animated:true, completion:nil)
       
    }
    
    //MARK:- delete portfolio API *******
    func deletePortfolio(){
        APIManager.sharedInstance.deletePortfolio(portfolioId: portfolioId){ (response) in
            self.dismiss(animated: true, completion: nil)
            self.delegate.reloadData()
        }
    }
    
    func initView(){
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
