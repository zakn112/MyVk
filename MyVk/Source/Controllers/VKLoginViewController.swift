//
//  VKLoginViewController.swift
//  MyVk
//
//  Created by Андрей Закусов on 27.10.2019.
//  Copyright © 2019 Закусов Андрей. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

class VKLoginViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Session.instance.token = KeychainWrapper.standard.string(forKey: "token") ?? ""
//        if Session.instance.token == "" {
            
            
            
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "oauth.vk.com"
            urlComponents.path = "/authorize"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: "7185998"),
                URLQueryItem(name: "display", value: "mobile"),
                URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                URLQueryItem(name: "scope", value: "262150,wall,friends,photos"),
                URLQueryItem(name: "response_type", value: "token"),
                URLQueryItem(name: "v", value: "5.68")
            ]
            
            let request = URLRequest(url: urlComponents.url!)
            
            let navigation = webView.load(request)
        
    //    }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if Session.instance.token != "" {
//            performSegue(withIdentifier: "loginSegue", sender: self)
//            return
//        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        
        decisionHandler(.cancel)
        
        Session.instance.token = token ?? ""
        
        KeychainWrapper.standard.set(token ?? "", forKey: "token")
        
        
        if Session.instance.token != "" {
            performSegue(withIdentifier: "loginSegueVK", sender: self)
        }
        
        
    }
    
    
    
    
}
