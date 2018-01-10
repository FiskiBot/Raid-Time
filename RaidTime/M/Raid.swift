//
//  Raid.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/8/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import Foundation

class Raid : NSObject, NSCoding, Codable {
    
    
    
    let ACTIVITY_KEY = "ActivityKey"
    let TIME_KEY = "TimeKey"
    let TITLE_KEY = "TitleKey"
    
    private var _activity : String!
    private var _time : String!
    private var _title : String!
    
    var activity : String {return _activity}
    var time : String {return _time}
    var title : String {return _title}
    
    
    init(activity: String, time: String, title: String) {
        self._activity = activity
        self._time = time
        self._title = title
    }
    


    override init() {}

    required convenience init?(coder aDecoder: NSCoder){
        self.init()
        self._activity = aDecoder.decodeObject(forKey: ACTIVITY_KEY) as? String
        self._time = aDecoder.decodeObject(forKey: TIME_KEY) as? String
        self._title = aDecoder.decodeObject(forKey: TITLE_KEY) as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._activity, forKey: ACTIVITY_KEY)
        aCoder.encode(self._time, forKey: TIME_KEY)
        aCoder.encode(self._title, forKey: TITLE_KEY)
    }
}
