//
//  ReceiptVC.swift
//  Curah Provider
//
//  Created by Netset on 31/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

struct ReceiptArray {
    var name:String!
    var price:Int!
}


class ReceiptVC: BaseClass,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taxAmountLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    var payablePrice = Double()
    var totalPrice = Int()
    var array = [Keywords]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarWithBackBtnAndTitle(title: "Receipt")
        setPrice()
    }
    
    func setPrice(){
        var price = Int()
        for data in array{
            price = price + Int(data.price!)!
        }
        
        totalPriceLbl.text = "$\(Double(round(100*payablePrice)/100))"
        let taxAmount = Double(totalPrice) - Double(payablePrice)
        let finalTax = "$\(Double(round(100*taxAmount)/100))"
        //taxAmountLbl.text = "$\(finalTax)"
        taxAmountLbl.text = finalTax
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return array.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReceiptCell
        cell.selectionStyle = .none
        cell.lblService.text = array[indexPath.row].name!
        cell.lblPrice.text = "$\(array[indexPath.row].price!)"
        
        
        return cell
    }
}

class ReceiptCell: UITableViewCell {
    
    @IBOutlet weak var lblService :UILabel!
    @IBOutlet weak var lblPrice :UILabel!
    
}
