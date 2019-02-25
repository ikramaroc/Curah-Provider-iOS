//
//  ViewController.swift
//  CurahApp
//
//  Created by Netset on 27/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit



class PortFolioVC: BaseClass {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var modalObj : ModalBase!
    var noPortfolioDataLbl = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupMenuBarButton()
        title = "Portfolio"
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
         getPortfolioList()
    }
    
    //MARK:- get portfolio list API *******
    func getPortfolioList(){
        APIManager.sharedInstance.getPortfolioList(){ (response) in
            self.modalObj = response
            
            if self.modalObj.portfolioList?.count == 0{
                self.noDataLbl()
            } else{
                self.noPortfolioDataLbl.isHidden = true
                self.collectionView.isHidden = false
            }
            self.collectionView.reloadData()
        }
    }
    
    func noDataLbl() {
        noPortfolioDataLbl = UILabel(frame: CGRect(x: 20, y: screenHeight/2 - 20, width: screenWidth-40, height: 30))
        noPortfolioDataLbl.backgroundColor = UIColor.clear
        noPortfolioDataLbl.textColor = UIColor.black
        noPortfolioDataLbl.font = UIFont(name: Constants.AppFont.fontAvenirRoman, size: 18)
        noPortfolioDataLbl.text = "No portfolio found"
        noPortfolioDataLbl.isHidden = false
        noPortfolioDataLbl.textAlignment = .center
        self.view.addSubview(noPortfolioDataLbl)
        self.collectionView.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAddPortfolio(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddPortfiloVC") as? AddPortfiloVC {
            vc.delegate1 = self
            self.present(vc, animated: true, completion: nil)
        }
        // self.performSegue(withIdentifier: "segueAddPortfolioVC", sender: nil)
    }
}

extension PortFolioVC:reloadDataProtocol,reloadDataAfterUpdationProtocol{
    func reloadListData() {
        reloadData()
    }
    
    func reloadData() {
        getPortfolioList()
    }
    
    
}

extension PortFolioVC :UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        guard self.modalObj != nil else {
            return 0
        }
        return self.modalObj.portfolioList?.count == 0 ? 0 : (self.modalObj.portfolioList?.count)!
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let data = self.modalObj.portfolioList?[indexPath.row]
        
        if self.modalObj.portfolioList?[indexPath.row].type == "I"
        {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? PortFolioImageCell {
                
                if (data!.file!.count != 0) {
                    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    activityView.center = CGPoint(x: (cell.imgView.bounds.size.width)/2, y: (cell.imgView.bounds.size.height)/2)
                    activityView.color = UIColor.lightGray
                    activityView.startAnimating()
                    cell.imgView.addSubview(activityView)
                    ImageLoader.sharedLoader.imageForUrl(urlString: (self.modalObj.url)! as String + (data!.file!) as String, completionHandler:{(image: UIImage?, url: String) in
                        cell.imgView.image = image
                        activityView.stopAnimating()
                        activityView.removeFromSuperview()
                    })
                }
                
                return cell
            }
        }
        else
        {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as? PortFolioVideoCell {
                
                if (data!.file!.count != 0) {
                    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    activityView.center = CGPoint(x: (cell.imgView.bounds.size.width)/2, y: (cell.imgView.bounds.size.height)/2)
                    activityView.color = UIColor.lightGray
                    activityView.startAnimating()
                    cell.imgView.addSubview(activityView)
                    ImageLoader.sharedLoader.imageForUrl(urlString: (self.modalObj.url)! as String + (data!.video_thumb!) as String, completionHandler:{(image: UIImage?, url: String) in
                        cell.imgView.image = image
                        activityView.stopAnimating()
                        activityView.removeFromSuperview()
                    })
                }
                
                return cell
            }
        }
        
        
        return UICollectionViewCell()
    }
}

extension PortFolioVC :UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PortFolioDetailVC") as? PortFolioDetailVC {
            let data = self.modalObj.portfolioList?[indexPath.row]
            vc.videoUrl = (self.modalObj.url)! as String + (data!.file!) as String
            
            if self.modalObj.portfolioList?[indexPath.row].type == "I"
            {
                vc.imageUrl = (self.modalObj.url)! as String + (data!.file!) as String
                vc.type = "image"
            }
            else
            {
                vc.imageUrl = (self.modalObj.url)! as String + (data!.video_thumb!) as String
                vc.type = "video"
            }
            vc.portfolioId = (data?.id)!
            vc.delegate = self
            vc.titleHeaderStr = (data?.title)!
            vc.descriptionStr = (data?.description)!
            present(vc, animated: true, completion: nil)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (collectionView.frame.size.width/3)-10, height: (collectionView.frame.size.width)/3-25)
    }
}

class PortFolioImageCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.borderColor = UIColor.gray.cgColor
        imgView.layer.borderWidth = 0.5
        
    }
    
}

class PortFolioVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.borderColor = UIColor.gray.cgColor
        imgView.layer.borderWidth = 0.5
        
    }
}
