//
//  RaidTimeSetVC.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/8/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import UIKit

class RaidTimeSetVC: UIViewController {

    let activities = ["Leviathan Raid", "Eater Of Worlds", "Nightfall Strike"]
    @IBOutlet weak var activityPicker: UIPickerView!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var activityTitle: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func setRaidReminder(_ sender: Any) {
        
    }
}


extension RaidTimeSetVC : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activities[row]
    }
}

extension RaidTimeSetVC : UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activities.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}
