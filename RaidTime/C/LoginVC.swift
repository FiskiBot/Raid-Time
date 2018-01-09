//
//  ViewController.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/2/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {
    var authSession : SFAuthenticationSession?
    let APIKey = "7f00e0511de5415d9e07196acb4d048b"
    let clientID = "13732"
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func authorize(_ sender: Any) {
        
        let callbackURL = "RaidTime://"
        let authURL = URL(string:"https://www.bungie.net/en/OAuth/Authorize/ClientID=\(clientID)&response_type=code")
        
        
        self.authSession = SFAuthenticationSession(url: authURL!, callbackURLScheme: callbackURL, completionHandler: { (callBack:URL?, error: Error?) in
            guard error == nil, let successURL = callBack else {
                print(error!)
                
                return
            }
            
            let token = self.getQueryStringParameter(url: (successURL.absoluteString), param: "token")
            
            
        })
        self.authSession?.start()
        
    }
    
}
