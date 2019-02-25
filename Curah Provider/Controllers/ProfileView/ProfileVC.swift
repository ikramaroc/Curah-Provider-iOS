//
//  ProfileVC.swift
//  CurahApp
//
//  Created by Netset on 28/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import FloatRatingView

class ProfileVC: BaseClass {
    
    let tabs = [
        ViewPagerTab(title: "MyService", image: nil),
        ViewPagerTab(title: "Schedule", image: nil),
        ViewPagerTab(title: "Bank info", image: nil),
        ViewPagerTab(title: "My Documents", image: nil)]
    fileprivate var myReviewsList : ModalBase?
    fileprivate var viewPager:ViewPagerController!
    fileprivate var options:ViewPagerOptions!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var viewSwipe: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblTotalReviews: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    
    var userData1 : UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuBarButton()
        let editBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "editWhiteCircle"), style: .plain, target: self, action: #selector(btnEdit))
        navigationItem.rightBarButtonItem = editBtn
        navigationItem.rightBarButtonItem?.tintColor = .white
        DispatchQueue.main.async {
            self.setSwipeView()
            self.options.viewPagerFrame = self.viewSwipe.bounds
        }
        
        userData1 = ModalShareInstance.shareInstance.modalUserData.userInfo
        
        self.setupBackBtn(tintClr: .white)
        self.getReviewsListAPI(call: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("UpdateRating"), object: nil)
        self.setUpUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UpdateRating"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        let userData = ModalShareInstance.shareInstance.modalUserData.userInfo
        self.lblTotalReviews.text = "(\(userData?.reviewCount ?? 0) Reviews)"
    }
    
    @IBAction func facebookBtnAction(_ sender: UIButton) {
        
        if userData1?.fbLink?.count != 0 {
             Progress.instance.displayAlert(userMessage: Validation.call.facebookLinkNotAvailable)
        } else {
            
            
            if (userData1?.fbLink?.validateUrl())!{
                let finalUrl = setUrl(str: (userData1?.fbLink!)!)
                if let url = URL(string: finalUrl) {
                    if #available(iOS 10, *){
                        UIApplication.shared.open(url)
                    }else{
                        UIApplication.shared.openURL(url)
                    }
                }
            }else{
                Progress.instance.displayAlert(userMessage: Validation.call.facebookLinkNotAvailable)
            }
        }
        
    }
    
    func setUrl(str:String) -> String{
        if str.contains("http") || str.contains("https"){
            return str
        }else{
            return "http://" + str
        }
    }
    
    @IBAction func instgramBtnAction(_ sender: UIButton) {
        if userData1?.fbLink?.count != 0 {
             Progress.instance.displayAlert(userMessage: Validation.call.instagramLinkNotAvailable)
        } else {
            
            
            if (userData1?.instaLink!.validateUrl())!{
                let finalUrl = setUrl(str: (userData1?.instaLink!)!)
                if let url = URL(string: finalUrl) {
                    if #available(iOS 10, *){
                        UIApplication.shared.open(url)
                    }else{
                        UIApplication.shared.openURL(url)
                    }
                }
            }else{
                Progress.instance.displayAlert(userMessage: Validation.call.instagramLinkNotAvailable)
            }
        }
    }
    
    func setUpUserData()  {
        let userData = ModalShareInstance.shareInstance.modalUserData.userInfo
        self.title = (userData?.firstname)! + " " +  (userData?.lastname)!
        // setNavigationBarWithBackBtnAndTitle(title: (userData?.firstname)! + " " +  (userData?.lastname)!)
        if !(userData?.profileImage?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: self.imgViewProfile.bounds.size.width/2, y: self.imgViewProfile.bounds.size.height/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            self.imgViewProfile.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (userData?.profileImageUrlApi)! as String + (userData?.profileImage)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.imgViewProfile.image  = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        self.lblTotalReviews.text = "(\(userData?.reviewCount ?? 0) Reviews)"
        if let rating = userData?.rating {
            ratingView.rating = Double(rating)!
        }
        self.lblLocation.text = userData?.address
        self.lblExperience.text = userData?.experience
        self.lblPhoneNo.text = userData?.phone
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.height / 2
        imgViewProfile.layer.borderWidth = 1
        imgViewProfile.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func tapGestureOnViewReviewsAct(_ sender: Any) {
        if self.myReviewsList == nil  {
            self.getReviewsListAPI(call: true)
        } else {
            if self.myReviewsList?.myReviews?.count == 0 {
                Progress.instance.displayAlert(userMessage: "No Reviews Found")
            } else {
                self.performSegue(withIdentifier: segueId.myReviews.rawValue, sender: self.myReviewsList)
            }
        }
    }
    
    // MARK:- Reviews List API
    func getReviewsListAPI(call:Bool) {
        APIManager.sharedInstance.getReviewListAPI(otherUserId:0) { (response) in
            self.myReviewsList = response
            self.lblTotalReviews.text = "(\(response.myReviews?.count ?? 0) Reviews)"
            ModalShareInstance.shareInstance.modalUserData.userInfo?.reviewCount = response.myReviews?.count
            SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)
            if call {
                if self.myReviewsList?.myReviews?.count == 0 {
                    Progress.instance.displayAlert(userMessage: (self.myReviewsList?.message)!)
                } else {
                    self.performSegue(withIdentifier: segueId.myReviews.rawValue, sender: self.myReviewsList)
                }
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.myReviews.rawValue {
            let objVC : ReviewListVC = segue.destination as! ReviewListVC
            objVC.reviews = sender as? ModalBase
        }
    }
    
    @objc func btnEdit(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setSwipeView(){
        //self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        options = ViewPagerOptions(viewPagerWithFrame: self.viewSwipe.bounds)
        options.tabType = ViewPagerTabType.basic
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont(name: "Avenir", size: 15)!
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        options.tabViewHeight = 40
        options.tabIndicatorViewHeight = 2
        options.tabIndicatorViewBackgroundColor  = GreenColor
        options.tabViewBackgroundDefaultColor = UIColor(red: 203/255.0, green: 161/255.0, blue: 182/255.0, alpha: 1.0)
        options.tabViewBackgroundHighlightColor = UIColor(red: 203/255.0, green: 161/255.0, blue: 182/255.0, alpha: 1.0)
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        self.addChildViewController(viewPager)
        self.viewSwipe.addSubview(viewPager.view)
        viewPager.didMove(toParentViewController: self)
    }
}

extension ProfileVC: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        if position == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyServicesVC") as! MyServicesVC
            return vc
        }else if position == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleVC
            return vc
        }else if position == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BankInfoVC") as! BankInfoVC
            return vc
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyDocumentsVC") as! MyDocumentsVC
            return vc
        }
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension ProfileVC: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
    }
    
    func didMoveToControllerAtIndex(index: Int) {
    }
    
}
