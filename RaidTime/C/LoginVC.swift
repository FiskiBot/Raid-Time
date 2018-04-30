//
//  ViewController.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/2/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import UIKit
import SafariServices


class LoginVC: UIViewController, SFSafariViewControllerDelegate {
    private struct Constants {
        static let applicationHeaderKey = "X-API-Key"
        
        
        static let applicationAPIKey = ""                         // <<< SETUP REQUIRED
        static let authenticationCodeURL = URL(string: "https://www.bungie.net/en/OAuth/Authorize")!     // <<< SETUP REQUIRED
        static let clientId = ""                                 // <<< SETUP REQUIRED
        static let clientSecret = ""                             // <<< SETUP REQUIRED
        
        // URLs
        static let authenticationURL = URL(string: "https://www.bungie.net/en/OAuth/Authorize?client_id=\(clientId)&response_type=code")!
        static let oauthTokenURL = URL(string: "https://www.bungie.net/Platform/App/OAuth/Token/")!
        
        //Bungie Request URLS
        
        static let platformBaseURL = "https://www.bungie.net/Platform/"
        static let getMembershipIDURL = "GetMembershipsForCurrentUser/"
        
    }
    
    
    @IBOutlet weak var ClanNameLbl: UILabel!
    @IBOutlet weak var memberIdNumberLbl: UILabel!
    
    @IBOutlet weak var clanMembersLbl: UILabel!
    var authURLWithClientID = URL(string: "https://www.bungie.net/en/oauth/authorize?client_id=13732&response_type=code")
    var authSession : SFAuthenticationSession?
    var session : URLSession?
    var gotCode = ""
    var getMembershipData : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //probably want to have a completion handler here to catch the token and do stuff with it.
    func fetchToken() {
        print("Fetch Token begins")
        session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: URL(string:"https://www.bungie.net/platform/app/oauth/token/")!)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //request.addValue("client_ID=13732", forHTTPHeaderField: "Client-ID")
        request.httpBody = "grant_type=authorization_code&code=\(gotCode)&client_id=13732".data(using: .utf8)
        request.httpMethod = "POST"
        session?.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                print(error.debugDescription)
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    DataService.ds.populateWith(json as? [String:Any])
                    print(json)
                    print(DataService.ds.accessToken)
                } catch {
                    print(">#>#>#>#>Error parsing data: \(error.localizedDescription)")
                }
            } else {
                print(">><<Error, NO DATA>><<")
            }
            }.resume()
    }

    @IBAction func authorize(_ sender: Any) {
        
        //Kick it off
        authSession = SFAuthenticationSession(url: authURLWithClientID!, callbackURLScheme: nil, completionHandler: { (callBack: URL?, error: Error?) in
            guard error == nil, let successURL = callBack else {
                return
            }
            
            print("***SUCCESSS***\(successURL)")
            
            let urlString = "\(successURL)"
            var split =  urlString.split(separator: "=")
            let authCode = split[1]
            print("Auth Code: \(authCode)")
            self.gotCode = "\(authCode)"
            print("Auth Code Complete")
            self.fetchToken()
        })
        authSession?.start()
        
    }
    

    @IBAction func getMembershipID(_ sender: Any) {
        session = URLSession(configuration: URLSessionConfiguration.default)
        
        var request = URLRequest(url: URL(string: "https://www.bungie.net/Platform/User/GetMembershipsForCurrentUser/")!)
        
        request.addValue("Bearer \(DataService.ds.accessToken!)", forHTTPHeaderField: "Authorization")
        request.addValue(Constants.applicationAPIKey, forHTTPHeaderField: Constants.applicationHeaderKey)
        //request.httpMethod = "GET"
        session?.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                print(error.debugDescription)
                return
            }
            if let response = response {
                do {
                    
                    //let json = try JSONSerialization.jsonObject(with: data!)
                    
                    //let jsonString =  String(data: data!, encoding: String.Encoding.utf8)
                    //print("READOUT INCOMING MEMBERSHIPS FOR CURRENT USER: \(jsonString!) ")
                    //MARK: Swift4 Decoding
                    
                    do {
                        let decoder = JSONDecoder()
                        let getData = try decoder.decode(
                            User.self, from: data!)
                        print("Decoded data: \(getData)")
                        if let destinyMembershipID = getData.Response.destinyMemberships![0].membershipId as? String {
                            DataService.ds.destinyMembershipID = destinyMembershipID
                            
                        }
                        if let membershipType = getData.Response.destinyMemberships![0].membershipType as? Int {
                        DataService.ds.membershipType = membershipType
                        }
                        
                        DispatchQueue.main.async {
                            self.memberIdNumberLbl.text = DataService.ds.membershipId
                        }
  
                    } catch {
                        print("##############################")
                        print("#Your decoder needs work dude#")
                        print("##############################")
                        print(error)
                    }
                    
                    //print("\(json)")
                } catch {
                    print("GET MEMBERSHIPS FROM BUNGO ID")
                    print(">#>#>#>#>Error parsing data: \(error.localizedDescription)")
                }
            } else {
                print(">><<Error, NO DATA>><<")
            }
            
            }.resume()
    }
    
    @IBAction func getClanID(_ sender: Any) {
        session = URLSession(configuration: URLSessionConfiguration.default)
        //you are going to have to handle when someone doesn't have a clan.
        print("STARTING CLAN ID FETCH")
        print("##########################")
        print("Destiny Membership ID: \(DataService.ds.destinyMembershipID)")
        print("Destiny Membership Type: \(DataService.ds.membershipType)")
        
        var groupIDURL = URL(string: "https://www.bungie.net/Platform/GroupV2/User/\(DataService.ds.membershipType)/\(DataService.ds.destinyMembershipID)/0/1/")
        var request  = URLRequest(url: groupIDURL!)
        request.addValue("Bearer \(DataService.ds.accessToken!)", forHTTPHeaderField: "Authorization")
        request.addValue(Constants.applicationAPIKey, forHTTPHeaderField: Constants.applicationHeaderKey)
        
        session?.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                print(error.debugDescription)
                return
            }
            if let response = response {
                do {
                    //let json = try JSONSerialization.jsonObject(with: data!)
                    let jsonString =  String(data: data!, encoding: String.Encoding.utf8)
                    print("READOUT OF CLAN ID: \(jsonString!) ")
                    
                    
                    let decoder = JSONDecoder()
                    //let getData = try decoder.decode
                    let getData = try decoder.decode(User.self, from: data!)
                    print("Decoded Clan Data: \(getData)")
                    if let clanID = getData.Response.results![0].member.groupId as? String {
                        DataService.ds.clanID = clanID
                    }
                    
                    if let clanName = getData.Response.results![0].group.name as? String {
                        DataService.ds.clanName = clanName
                    }
                    
                    DispatchQueue.main.async {
                        self.ClanNameLbl.text =  "Clan Name: \(DataService.ds.clanName)"
                    }

                } catch  {
                    print("#*#*#*#CLAN ID PARSING FAILED#*#*#*#")
                    print(error)
                }
            } else {
                print("Request Failed")
            }
        }.resume()
    }
    
    @IBAction func getMembersOfClan(_ sender: Any) {
        
        session = URLSession(configuration: URLSessionConfiguration.default)
        var clanURL = URL(string: "https://www.bungie.net/Platform/GroupV2/\(DataService.ds.clanID)/Members/")
        var request = URLRequest(url: clanURL!)
        request.addValue("Bearer \(DataService.ds.accessToken!)", forHTTPHeaderField: "Authorization")
        request.addValue(Constants.applicationAPIKey, forHTTPHeaderField: Constants.applicationHeaderKey)
        
        session?.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                print(error.debugDescription)
                return
            }
            if let response = response {
                do {
                    let jsonString = String(data: data!, encoding: String.Encoding.utf8)
                    print(jsonString)
                    let json = try JSONSerialization.jsonObject(with: data!)
                    print("CERALIZED JSON FOR CLAN MEMBERS: \(json)")
                    
//                    let decoder = JSONDecoder()
//                    let getData = decoder.decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
                    
                } catch {
                    print("Didn't Get Clan Mates")
                    print(error)
                }
            }
        }.resume()
    }
}
