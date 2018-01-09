//
//  Colors.swift
//  UpsalesBasicClients
//
//  Created by NTW-laptop on 09/01/18.
//  Copyright © 2018 NTW - Web Technology. All rights reserved.
//


import Foundation
import SwiftyJSON
import Alamofire


enum NetworkError {
    case Connection, ServerError, NotFound, EncodeLocal, UnexpectedJSON, WrongResult, Authorization
}



extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

struct NetworkErrorMessage {
    let title: String
    let desc: String
}

class CoreNetwork {
    
    
    static func messageFromError(_ error: NetworkError) -> NetworkErrorMessage {
        switch error {
        case .EncodeLocal:
            return NetworkErrorMessage(title: NSLocalizedString("error.title.internal", comment: ""), desc: NSLocalizedString("error.desc.internal.update", comment: ""))
        case .Connection:
            return NetworkErrorMessage(title: NSLocalizedString("error.title.connection", comment: ""), desc: NSLocalizedString("error.desc.connection", comment: ""))
        case .NotFound:
            return NetworkErrorMessage(title: NSLocalizedString("error.title.simple", comment: ""), desc: NSLocalizedString("error.desc.not_found", comment: ""))
        case .ServerError:
            return NetworkErrorMessage(title: NSLocalizedString("error.title.server", comment: ""), desc: NSLocalizedString("error.desc.contact_admin", comment: ""))
        case .Authorization:
            return NetworkErrorMessage(title: NSLocalizedString("error.title.auth", comment: ""), desc: NSLocalizedString("error.desc.auth", comment: ""))
        default:
            return NetworkErrorMessage(title: NSLocalizedString("error.title.server", comment: ""), desc: NSLocalizedString("error.desc.wrong_json", comment: ""))
        }
    }
    
    var vController: UIViewController?
    var url: String
    var success: (JSON) -> ()
    var in_error: (NetworkError) -> ()
    var method: Alamofire.HTTPMethod = Alamofire.HTTPMethod.get
    var params: Dictionary<String, String>?
    var alamofireManager : Alamofire.SessionManager!
    var parameterEncoding: ParameterEncoding = JSONEncoding.default
    var customHeaders : Dictionary<String, String>?
    
    init(vController: UIViewController?, url: String, success: @escaping (JSON) -> (), in_error: @escaping (NetworkError) -> ()) {
        self.url = url
        self.vController = vController
        self.success = success
        self.in_error = in_error
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 15 // seconds
        configuration.timeoutIntervalForRequest = 10
        
        alamofireManager = SessionManager.default
    }
    
    convenience init(vController: UIViewController?, url: String, success: @escaping (JSON) -> (), in_error: @escaping (NetworkError) -> (), method: Alamofire.HTTPMethod, params: Dictionary<String,String>?, encoding: ParameterEncoding = JSONEncoding.default) {
        self.init(vController: vController,url: url,success: success,in_error: in_error)
        self.method = method
        self.params = params
        self.parameterEncoding = encoding
    }
    
   
    
    
    private func handleResponse(response: DataResponse<Any>) {
        if (response.result.error != nil) {
            if let controller = vController {
                let connectionError = CoreNetwork.messageFromError(.Connection)
                UIHelpers.presentDialog(title: connectionError.title,message: connectionError.desc ,vController: controller)
            }
         
            self.in_error(.Connection)
           
            return
        }
        let status = response.response?.statusCode
        switch status! {
        case 401:
            if let controller = vController {
                let connectionError = CoreNetwork.messageFromError(.Authorization)
                UIHelpers.presentDialog(title: connectionError.title,message: connectionError.desc ,vController: controller)
                
            }
            self.in_error(.Authorization)
            break
        case 500:
            if let controller = vController {
                let connectionError = CoreNetwork.messageFromError(.ServerError)
                UIHelpers.presentDialog(title: connectionError.title,message: connectionError.desc ,vController: controller)
                
            }
            self.in_error(.ServerError)
            break
        case 404:
            if let controller = vController {
                let connectionError = CoreNetwork.messageFromError(.NotFound)
                UIHelpers.presentDialog(title: connectionError.title,message: connectionError.desc ,vController: controller)
            }
            self.in_error(.NotFound)
            break
        default:
            if let json = response.result.value {
                
                
                let json = JSON(json)
                
                if json["error"].string != nil  {
                    
                    if let controller = vController {
                        let connectionError = CoreNetwork.messageFromError(.ServerError)
                        UIHelpers.presentDialog(title: connectionError.title,message: connectionError.desc ,vController: controller)
                        
                    }
                    self.in_error(.ServerError)
                    
                    
                } else {
                    self.success(json)
                }
            }
        }
        
    }
    
    
    public func fetchData() {
        
        print("NETWORKING - Request URL: " + self.url)
        alamofireManager.request(self.url,method: self.method, parameters: params != nil ? params : nil, encoding: self.parameterEncoding, headers: [:]).validate(statusCode: 200..<402)
                .responseJSON { response in
                    self.handleResponse(response: response)
            }
        
        
    }
    
    
 
    

    
    
}
