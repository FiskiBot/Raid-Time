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
    var time : Date = Date()
    var title : String?
    
    init(activity: String, time: Date, title: String?) {
        self.activity = activity
        self.time = time
        self.title = title
    }
    
}
