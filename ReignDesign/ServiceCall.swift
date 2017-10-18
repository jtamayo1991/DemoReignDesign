//
//  ServiceCall.swift
//  ReignDesign
//
//  Created by admin on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Alamofire

class ServiceCall {
    
    init() {
        
    }
    class func getData(completion : @escaping (Any) -> Void){
        
        
        
        let urlservice : String = "http://hn.algolia.com/api/v1/search_by_date?query=ios"
        Alamofire.request(
            URL(string: urlservice)!,
            method: .get)
            .validate()
            .responseString { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion(false)
                    return
                }
                guard let responseJSON = response.result.value else {
                    print("Invalid tag information received from the service")
                    completion(false)
                    return
                }
                
                let jsonResponse = JSONWebService(json: responseJSON)
                
                completion(jsonResponse)
        }
    }
}
