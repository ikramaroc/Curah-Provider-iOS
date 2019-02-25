//
//  BankinfoVC.swift
//  CurahApp
//
//  Created by Netset on 28/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

class BankInfoVC: BaseClass,UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicatorVw: UIActivityIndicatorView!
    
    var stripeUrl:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLCache.shared.removeAllCachedResponses()
        getBankDetail()
        self.title = "Add Bank Detail"
        self.navigationItem.title = "Add Bank Detail"
        self.underLineTextFldBottomLine(mainView: self.view, borderColor: UIColor.black)
        self.rightBarButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name:Constants.AppFont.fontAvenirHeavy, size:20) as Any, NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name:Constants.AppFont.fontAvenirHeavy, size:20) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func rightBarButton() {
        
        if self.navigationController != nil{
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            for aviewcontroller : UIViewController in viewControllers{
                if aviewcontroller.isKind(of: AddServicesVC.self){
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipAct))
                    self.navigationItem.rightBarButtonItem?.tintColor = .black
                    self.navigationItem.title = "Add Bank Detail"
                    self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name:Constants.AppFont.fontAvenirRoman, size:15)!], for: .normal)
                    self.navigationController?.navigationBar.isHidden = false
                    
                }
            }
        }
    }
    
    func rightBarButtonUpdate() {
        
        if self.navigationController != nil{
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            for aviewcontroller : UIViewController in viewControllers{
                if aviewcontroller.isKind(of: AddServicesVC.self){
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(skipAct))
                    self.navigationItem.rightBarButtonItem?.tintColor = .black
                    self.navigationItem.title = "Add Bank Detail"
                    self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name:Constants.AppFont.fontAvenirRoman, size:15)!], for: .normal)
                    self.navigationController?.navigationBar.isHidden = false
                    
                    
                }
            }
        }
    }
    
    
    @objc func skipAct() {
        comeFromBank = true
        
        UserDefaults.standard.removeObject(forKey: "USERDETAILS")
        UserDefaults.standard.synchronize()
        ModalShareInstance.shareInstance.modalUserData = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.makingRoot("initial")
    }
    // Do any additional setup after loading the view.
    
    
    func getBankDetail(){
        APIManager.sharedInstance.getBankAPI{ (response) in
            if (response.bankDetails != nil){
                let url = URL (string: (response.bankDetails?.dashboard_link!)!)
                let request = URLRequest(url: url!)
                self.webView.loadRequest(request)
            }else {
                let url = URL (string: response.url!)
                let request = URLRequest(url: url!)
                self.webView.loadRequest(request)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicatorVw.startAnimating()
        print("WEB VIEW Start Loading...")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        indicatorVw.stopAnimating()
        indicatorVw.hidesWhenStopped = true
        let str = self.webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")!
        if str.contains("status"){
            let startIndexJSON  = str.index(of: Character.init("{"))
            let endIndexJSON  = str.index(of: Character.init("}"))
            if startIndexJSON != nil && endIndexJSON != nil {
                let finalStr =  str.substring(start: startIndexJSON!, end: endIndexJSON! + 1)
                print("\n\n Final Str  = \(finalStr)")
                
                if finalStr.contains("status"){
                    let finalJSON : NSDictionary = self.convertToDictionary(text: finalStr)! as NSDictionary
                    print("Final JSON = \(finalJSON)")
                    if let status: Int = finalJSON.value(forKey: "status") as? Int{
                        if status == 200{
                            
                            self.getBankDetail()
                            self.rightBarButtonUpdate()
                            
                        }
                    }
                    
                    
                    /*else{
                     let alert = UIAlertController(title: "Alert", message: finalJSON.value(forKey: "message") as? String, preferredStyle: UIAlertControllerStyle.alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                     switch action.style{
                     case .default:
                     print("default")
                     
                     case .cancel:
                     print("cancel")
                     
                     case .destructive:
                     print("destructive")
                     
                     }}))
                     self.present(alert, animated: true, completion: nil)
                     }*/
                }
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension String {
    public func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }
    
    func substring(start: Int, end: Int) -> String{
        if (start < 0 || start > self.count){
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.count{
            print("end index \(end) out of bounds")
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        
        return self.substring(with: range)
    }
}
