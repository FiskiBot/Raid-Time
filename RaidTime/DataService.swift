//
//  DataService.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/8/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import Foundation

class DataService {
    static let ds = DataService()
    
    let RAID_KEY = "raidKey"
    
    private var _loadedRaids = [Raid]()
    
    var loadedRaids : [Raid] {
        return _loadedRaids
    }
    
    func saveRaid() {
        let raidData = NSKeyedArchiver.archivedData(withRootObject: _loadedRaids)
        UserDefaults.standard.set(raidData, forKey: RAID_KEY)
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
}
