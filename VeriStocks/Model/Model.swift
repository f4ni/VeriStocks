//
//  Model.swift
//  VeriStocks
//
//  Created by f4ni on 14.05.2021.
//


import UIKit

struct StockBundle: Codable {
    var stocks: [Stock]?
    var status: ResponseStatus?
   
}

struct Stock: Codable {
    var id: Int?
    var isDown: Bool?
    var isUp: Bool?
    var bid: Float?
    var difference: Float?
    var offer: Float?
    var price: Float?
    var volume: Float?
    var symbol: String?
    var change: Float?
    var count: Int?
    var highest: Float?
    var lowest: Float?
    var maximum: Float?
    var minimum: Float?
    var graphicData: [GraphicData]?
    var status: ResponseStatus?
    
}

struct GraphicData: Codable {
    var day: Int?
    var value: Float?
}

struct HandShakeRequest: Codable {
    var deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var systemVersion = UIDevice.current.systemVersion
    var platformName = UIDevice.current.systemName
    var deviceModel = UIDevice.current.model
    var manifacturer = "Apple"
}

struct StaticModel {
    public static var sideMenuHeaderImageUrl = "https://lh6.googleusercontent.com/SdaGtlv__GgXdqxn7FB9gazrcjSwVHl_LC0AIyCEFNOW3o8WIlMbk-6q5ew7LikMkf6LN0GRCJencdUDXHCb"
}

struct AuthorizationModel: Codable {
    var aesKey: String
    var aesIV: String
    var authorization: String
    var lifeTime: String
    var status: ResponseStatus
}

struct ResponseStatus: Codable {
    var isSuccess: Bool
    var error: ResponseStatusError
    
}

struct ResponseStatusError: Codable {
    var code: Int
    var message: String
}

struct RequestModel: Codable {
    var id: String?
    var period: String?
}
