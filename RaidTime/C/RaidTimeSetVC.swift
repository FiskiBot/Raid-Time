//
//  RaidTimeSetVC.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/8/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import UIKit
import UserNotifications

class RaidTimeSetVC: UIViewController, UITextFieldDelegate {
    let UNCenter = UNUserNotificationCenter.current()
    let activities = ["Leviathan Raid", "Eater Of Worlds", "Nightfall Strike", "Trial of the Nine"]
    @IBOutlet weak var activityPicker: UIPickerView!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var activityTitle: UITextField!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifications()
        activityTitle.delegate = self
    }
    func registerForNotifications() {
        UNCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Request Authorization
                self.UNCenter.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (success, error) in
                    print("Notification Authorization: \(success)")
                    
                    UIApplication.shared.registerForRemoteNotifications()
                })
            case .authorized:
                print("Notifications Allowed")
                UIApplication.shared.registerForRemoteNotifications()
            case .denied:
                print("Notifications Denied")
            }
        }
    }
    
    func setNotification() {
        var selectedActivity = activities[activityPicker.selectedRow(inComponent: 0)]
        
        let codeGen = UUID().uuidString
        print(codeGen)
        let notificationContent = UNMutableNotificationContent()
        //TODO: Change this to allow a check in on the back end.
        let checkIn = UNNotificationAction(identifier: "Checkin", title: "Check In", options: [.destructive])
        
        
        
        notificationContent.title = activityTitle.text!
        notificationContent.subtitle = selectedActivity
        
        let interval = dateTimePicker.date.timeIntervalSinceNow
        notificationContent.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")
        notificationContent.categoryIdentifier = "Reminder"
        notificationContent.sound = UNNotificationSound.init(named: "itsTime.wav")
        notificationContent.body = ""
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        let category = UNNotificationCategory(identifier: "Reminder", actions: [checkIn], intentIdentifiers: [], options: [])
        let request = UNNotificationRequest(identifier: "RaidNotification\(codeGen)", content: notificationContent, trigger: notificationTrigger)
        UNCenter.setNotificationCategories([category])
        //TODO: Add a completion handler that connects back to the backend.
        UNCenter.add(request, withCompletionHandler: nil)

    }
    
    @IBAction func setRaidReminder(_ sender: Any) {
        var selectedActivity = activities[activityPicker.selectedRow(inComponent: 0)]
        var dateFormatted = DateFormatter.localizedString(from: dateTimePicker.date, dateStyle: .medium, timeStyle: .medium)
        

        var newRaid = Raid(activity: selectedActivity, time: dateFormatted, title: activityTitle.text!)
        
        DataService.ds.addRaid(raid: newRaid)
        setNotification()
        _ = navigationController?.popViewController(animated: true)
        
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
