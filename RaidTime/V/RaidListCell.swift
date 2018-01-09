//
//  RaidListCell.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/8/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import UIKit

class RaidListCell: UITableViewCell {


    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var activityLbl: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell (raid: Raid) {
        titleLbl.text = raid.title
        activityLbl.text = raid.activity
        dateTime.text = raid.time
    }
    

}
