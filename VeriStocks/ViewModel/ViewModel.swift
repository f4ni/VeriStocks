//
//  ViewModel.swift
//  VeriStocks
//
//  Created by f4ni on 14.05.2021.
//

import Foundation


struct StockViewModel: Codable {
    var id: Int
    var isDown: Bool
    var isUp: Bool
    var difference: String
    var offer: String
    var price: String
    var volume: String
    var symbol: String
    var bid: String
    var change: String
    var count: String
    var highest: String
    var lowest: String
    var maximum: String
    var minimum: String
    var graphicData: [GraphicData]?
    var status: ResponseStatus?
    
    
    init(stock: Stock) {
        let auth = APIService.instance.authorization
        
        self.id     = stock.id ?? 0
        self.isDown = stock.isDown ?? false
        self.isUp   = stock.isUp ?? false
        self.difference = "\(stock.difference ?? 0)"
        self.offer  = "\(stock.offer ?? 0)"
        self.price  = "\(stock.price ?? 0)"
        self.volume = String("\(stock.volume ?? 0)".prefix(3))
        self.bid    =   "\(stock.bid ?? 0)"
        self.symbol = stock.symbol?.AESDecryptWithBase64(keyBase64: auth!.aesKey, ivBase64: auth!.aesIV) ?? ""
        self.change = (stock.isUp ?? false ? "⬆️": (stock.isDown ?? false ? "⬇️" : "➡️"))
        self.count = "\(stock.count ?? 0)"
        self.highest = "\(stock.highest ?? 0)"
        self.lowest = "\(stock.lowest ?? 0)"
        self.maximum = "\(stock.maximum ?? 0)"
        self.minimum = "\(stock.minimum ?? 0)"
        self.graphicData = stock.graphicData
        self.status = stock.status

    }
}
