//
//  DataService.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/8/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import Foundation

struct User : Codable {
    let Response : Response
}

struct Response : Codable {
    let bungieNetUser : BungieUser?
    let destinyMemberships : [DestinyMembership]?
    let results : [Clan]?
}

struct BungieUser : Codable {
    let about : String
    let displayName : String
    let profilePicture : Int
    let profilePicturePath : String
}

struct DestinyMembership : Codable {
    let displayName : String
    let iconPath : String
    let membershipId : String
    let membershipType : Int
}

struct Clan : Codable {
    let member : ClanMember
    let group : ClanInfoBasic
}

struct ClanInfoBasic : Codable {
   let name : String
}

struct ClanMember : Codable {
    let memberType : Int
    let isOnline : Bool
    let groupId : String
    let destinyUserInfo : DestinyMembership
 
}

class DataService : Codable{
    static let ds = DataService()
    var accessToken: String?
    var expiresIn: Int = 0
    var refreshToken: String?
    var refreshExpiresIn: Int = 0
    
    
    var tokenType: String = "Unknown"
    var membershipId: String = "Unknown"
    
    var creationTime : Date = Date(timeIntervalSince1970: 0)
    //Destiny Specific values
    var destinyMembershipID : String = "Destiny Membership ID Unknown"
    var destinyDisplayName : String = "Destiny Display Name Unknown"
    var membershipType : Int = 0
    var iconPath : String = "Unknown Icon Path"
    
    //Clan info
    var clanID : String = "Destiny Clan Unknown"
    var clanName : String = "Clan Name Unknown"
    
    //MARK: Auth and API Network Calls
    func populateWith(_ json: [String:Any]?) {
        guard let json = json else {
            return
        }
        
        if let accessToken = json["access_token"] { self.accessToken = accessToken as? String }
        if let refreshToken = json["refresh_token"] { self.refreshToken = refreshToken as? String }
        if let tokenType = json["token_type"] { self.tokenType = tokenType as? String ?? "" }
        if let membershipId = json["membership_id"] { self.membershipId = membershipId as? String ?? "Unknown" }
        if let expiresIn = json["expires_in"] { self.expiresIn = expiresIn as? Int ?? -1 }
        if let refreshExpiresIn = json["refresh_expires_in"] { self.refreshExpiresIn = refreshExpiresIn as? Int ?? -1 }
        
        creationTime = Date()
        
        print(">>> Authentication information:")
        print(self)
    }
    
    func findDestinyMembershipID(_ json: [String:Any]?) {
        guard let json = json else {
            
            return
        }
        print("json -> \(json)")
        if let bungieMemberships = json["bungieNetUser"] as? [String:Any]{
            print("Bungie member info -  \(bungieMemberships)")
            if let destinyMemberships = bungieMemberships["destinyMemberships"] as? [String:String] {
                if let membershipId = destinyMemberships["membershipID"] {
                    self.membershipId = membershipId
                    print("You Got your self a membership ID Muthafucker! - \(self.membershipId)")
                } else {
                    print("Could not get membership ID")
                }
            } else {
                
                print("Could not get destiny memberships")
            }
        }
    }
    
    //MARK: Table View
    let RAID_KEY = "raidKey"
    
    private var _loadedRaids = [Raid]()

    var loadedRaids : [Raid] {
        return _loadedRaids
    }
    
    func saveRaid() {
        
        let raidData = NSKeyedArchiver.archivedData(withRootObject: _loadedRaids)
        UserDefaults.standard.set(raidData, forKey: RAID_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func loadRaid(){
        if let raidData = UserDefaults.standard.object(forKey: RAID_KEY) as?  Data {
            if let raidArray = NSKeyedUnarchiver.unarchiveObject(with: raidData) as? [Raid] {
                _loadedRaids = raidArray
            }
        }
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "raidLoaded")))
    }
    
    func addRaid(raid: Raid) {
        _loadedRaids.append(raid)
        saveRaid()
        loadRaid()
        
    }
    
    func deleteRaid(index: Int) {
        _loadedRaids.remove(at: index)
        saveRaid()
        loadRaid()
    }
}
