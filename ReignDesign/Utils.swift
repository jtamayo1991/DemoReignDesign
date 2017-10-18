//
//  Utils.swift
//  ReignDesign
//
//  Created by admin on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Utils{
    
    init(){
    }
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    class func dateFromString(dateToFormat : String) -> Date{
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormat = dateFormatter.date(from:dateToFormat)!
        
        return dateFormat
    }
    
    class func makeSimpleAlert(title: String, subtitle: String) -> UIAlertController{
      
        
        let subtitle = subtitle
        let title = title
        
        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "ok", style: .cancel) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(cancel)
        
        return alertController
    }
}
