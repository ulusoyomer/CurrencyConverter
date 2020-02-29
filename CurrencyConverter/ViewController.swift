//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by omer on 29.02.2020.
//  Copyright © 2020 omer. All rights reserved.
//

import UIKit
import iOSDropDown
class ViewController: UIViewController{
    
    @IBOutlet weak var dropDpwnList: DropDown!
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var btnConvert: UIButton!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var textAreaResult: UITextView!
    @IBOutlet weak var tfTRY: UITextField!
    
    var moneyArray = [Money]()
    

    var calValue:Double = 0.0
    var tempString:String = ""
    
    let url = URL(string: "https://finans.truncgil.com/today.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = URLSession.shared
        textAreaResult.isEditable = false
        self.dropDpwnList.optionArray.append("All")
        let task = session.dataTask(with: url!) {
            (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "Veriler Alınamadı", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Okey", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                if data != nil {
                    do {
                        let results1 = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        var i = 0
                        for results in results1 {
                            if results.key != "Güncelleme Tarihi" {
                                let result = results.value as! [String: Any]
                                if !results.key.contains("ÖZEL ÇEKME HAKKI (SDR)") {
                                    
                                    var moneySellString = result["Satış"] as! String
                                    var moneyBuyString = result["Alış"] as! String
                                    moneyBuyString = moneyBuyString.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)
                                    moneySellString = moneySellString.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)
                                    if let moneyBuy = Double(moneyBuyString) {
                                        if let moneySell = Double(moneySellString) {
                                            self.moneyArray.append(Money(moneyName: results.key, moneyBuy: moneyBuy, moneySell: moneySell))
                                            DispatchQueue.main.async {
                                                self.dropDown.optionArray.append(results.key)
                                                self.dropDpwnList.optionArray.append(results.key)
                                                self.textAreaResult.text.append("\(self.moneyArray[i].moneyName) Alış = \(self.moneyArray[i].moneyBuy) Satış = \(self.moneyArray[i].moneySell) \n------------------------------------------------\n")
                                                i += 1
                                                self.tempString = self.textAreaResult.text
                                            }

                                        }
                                    }
                                }
                            }

                        }
                    } catch {
                        print("json Error")
                    }
                }
            }
        }

        task.resume()
        btnConvert.layer.cornerRadius = 10
        dropDown.didSelect {
            (selectedText, index, id) in
            for money in self.moneyArray {
                if money.moneyName == selectedText {
                    
                    self.calValue = money.moneySell
                }
            }
        }
       dropDpwnList.didSelect {
            (selectedText, index, id) in
            for money in self.moneyArray {
                if money.moneyName == selectedText {
                    DispatchQueue.main.async {
                        self.textAreaResult.text = "\(money.moneyName) Alış = \(money.moneyBuy) Satış = \(money.moneySell)"
                    }
                }else {
                    if selectedText == "All"{
                        DispatchQueue.main.async {
                            self.textAreaResult.text = self.tempString
                        }
                    }
                }
            }
        }

    }
    @IBAction func btnConvertOnClick(_ sender: Any) {
        if (tfTRY.text != "") && (tfTRY.text != nil) && (calValue != 0.0){
            if var turkey = Double(tfTRY.text!){
                turkey = turkey/calValue
                lbResult.text = "Result = \(turkey)"
                view.endEditing(true)
            }else{
                throwError()
            }
        }else{
            throwError()
        }
    }
    func throwError(){
        let alert = UIAlertController(title: "Boş Veri Hatası", message: "Lütfen boş bırakmayınız ve , yerine . kullanınız. Para birimi seçmeyi unutmayınız.", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okey", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
