//
//  APIService.swift
//  VeriStocks
//
//  Created by f4ni on 13.05.2021.
//


import Alamofire
import SwiftyJSON
import CryptoSwift

class APIService {
    static let instance = APIService()
    
    var authorization: AuthorizationModel?

    let handShakeHeaders: HTTPHeaders = [
        "POST": "/api/handshake/start",
        "Content-Type": "application/json"
    ]
    
    var requestHeaders: HTTPHeaders = [
        "POST": "/api/stocks/list",
        "Content-Type": "application/json",
        "X-VP-Authorization": "{{authorization}}"
    ]

    let handShakeStartUrl = "https://mobilechallenge.veripark.com/api/handshake/start"
    
     func handShaking( completion: @escaping (AuthorizationModel) -> Void ){
        //print(self.handShakeStartUrl)
        if authorization == nil {
            let requestModel = HandShakeRequest()
            
            AF.request(self.handShakeStartUrl, method: .post, parameters: APIService.toParameters(model: requestModel), encoding: JSONEncoding.default, headers: handShakeHeaders)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value as [String: AnyObject]):
                        do{
                            let responseJsonData = JSON(value)
                             let responseModel = try JSONDecoder().decode(AuthorizationModel.self, from: responseJsonData.rawData())
                            Dispatch.DispatchQueue.main.async {
                                self.authorization = responseModel
                                completion(responseModel)
                            }
                        }
                        catch let parsingError {
                            print("handshaking fetch success but: \(parsingError)")
                        }
                 
                    case .failure(let error):
                        print("failure '\(self.handShakeStartUrl)': \(error)")
                    //completion(error)
                    default:
                        fatalError("fatal error")
                    }
                }
        }
        else {
            completion(self.authorization!)
        }
        
    }
    
    
    
     func fetch<T: Codable> ( method: HTTPMethod, url: String, parameters: [String: Any]?, model: T.Type, completion: @escaping (AFResult<Codable>) ->Void ){

        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: self.requestHeaders)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String: AnyObject]):
                    do{
                        let responseJsonData = JSON(value)
                        let responseModel = try JSONDecoder().decode(model.self, from: responseJsonData.rawData())
                        completion(.success(responseModel))
                    }
                    catch let parsingError {
                        print("fetch success but: \(parsingError)")
                    }

                case .failure(let error):
                print("failure '\(url)': \(error)")
                completion(.failure(error))
                default:
                    fatalError("fatal error")
                }
            }
    }
    
    
    public func fetchStocks(type: String, completion: @escaping(AFResult<Codable>) ->Void ){

        let urlString = "https://mobilechallenge.veripark.com/api/stocks/list"
        
        handShaking() { HSResponse in
            if HSResponse.status.isSuccess{
                
                guard let auth = self.authorization else { return }

                self.requestHeaders.update(name: "X-VP-Authorization", value: auth.authorization)
                
                let period = type.AESEncryptWithBase64(keyBase64: auth.aesKey, ivBase64: auth.aesIV)
                
                let parameter = ["period": period]
                self.fetch( method: .post, url: urlString, parameters: parameter as [String : Any], model: StockBundle.self) { (res) in
                    completion(res)
                }
            }
        }

    }
    public func fetchStockDetail(id: Int, completion: @escaping(AFResult<Codable>) ->Void ){

        let urlString = "https://mobilechallenge.veripark.com/api/stocks/detail"
        handShaking() { HSResponse in
            if HSResponse.status.isSuccess{
                
                guard let auth = self.authorization else { return }
                
                self.requestHeaders.update(name: "POST", value: "/api/stocks/detail")
                                
                let idEncrypted = "\(id)".AESEncryptWithBase64(keyBase64: auth.aesKey, ivBase64: auth.aesIV)
                
                let parameter = ["id": idEncrypted]
                
                self.fetch( method: .post, url: urlString, parameters: parameter as [String : Any], model: Stock.self) { (res) in
                    completion(res)
                }
            }
        }

    }
    
    static func toParameters<T:Encodable>(model: T?) -> [String: AnyObject]? {
        if model == nil {
            return nil
        }
        
        let jsonData = modelToJson(model: model)
        let parameters = jsonToParameters(from: jsonData!)
        return parameters! as [String: AnyObject]
    }
    
    static func modelToJson<T:Encodable>(model: T)-> Data? {
        return try? JSONEncoder().encode(model.self)
    }
    
    static func jsonToParameters(from data: Data) ->[String: Any]? {
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
    
}

