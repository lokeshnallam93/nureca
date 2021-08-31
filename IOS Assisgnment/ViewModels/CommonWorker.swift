//
//  CommonWorker.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 29/08/21.
//

import Foundation
import Alamofire
class CommonWorker {
    
    public func callRequest(url: URL, method:HTTPMethod, parameter:Parameters?, encoding:ParameterEncoding, headers:HTTPHeaders, callBack: @escaping (_ result: AFDataResponse<Any>, _ error: AFError?)->()){
        
        AF.request(url, method: method, parameters: parameter, encoding: encoding, headers: headers).responseJSON(  completionHandler: { (response) in
            
            do{
                let code = response.response != nil ?  response.response!.statusCode : -1000

                if code == 200 {
                    callBack(response,nil)
                }else{
                    if response.error != nil{
                        callBack(response,response.error?.asAFError)
                    }
                }
            }catch{
                callBack(response,nil)
            }
            
        })
        
    }
}
