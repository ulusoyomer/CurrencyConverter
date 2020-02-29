//
//  Money.swift
//  CurrencyConverter
//
//  Created by omer on 29.02.2020.
//  Copyright © 2020 omer. All rights reserved.
//

import Foundation

class Money {
    var moneyName:String
    var moneyBuy:Double
    var moneySell:Double
    
    init(moneyName:String,moneyBuy:Double,moneySell:Double) {
        self.moneyBuy = moneyBuy
        self.moneyName = moneyName
        self.moneySell = moneySell
    }
}
