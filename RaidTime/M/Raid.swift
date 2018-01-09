//
//  Raid.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/8/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import Foundation

class Raid : NSObject {
    
    var activity : String = ""
    var time : String
    var title : String
    
    init(activity: String, time: String, title: String) {
        self.activity = activity
        self.time = time
        self.title = title
    }
    
}
