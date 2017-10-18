//
//  WebViewController.swift
//  ReignDesign
//
//  Created by admin on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//


import UIKit
import PKHUD

class WebViewController: UIViewController, UIWebViewDelegate {
    

    @IBOutlet weak var myWebView: UIWebView!
     var urlShow : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWebView.delegate = self
        
        let myURL = NSURL(string: urlShow)
        let myReq = NSURLRequest(url: myURL as! URL)
        myWebView.loadRequest(myReq as URLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        HUD.show(.progress, onView: self.myWebView)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
