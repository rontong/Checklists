//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ronald Tong on 14/6/18.
//  Copyright © 2018 StokeDesign Co. All rights reserved.
//

import Foundation
import UserNotifications
// Tells ChecklistItem about the UserNotifications framework (to use UNUserNotificationCenter and other UN commands later)

class ChecklistItem: NSObject, NSCoding {
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    // Loads objects (decode) from the plist file
    // Has to be implemented to conform to the NSCoding protocol (in ChecklistViewController)
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    // Calls the class function in DataModel, receives an itemID in return
    
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    func toggleChecked() {
        checked = !checked
    }
    
    //! reverses the meaning of the value
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    // Saves (encode) objects to plist
    // Has to be implemented to conform to the NSCoding protocol (in ChecklistViewController)
    
    func scheduleNotification() {
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
           
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled notification \(request) for itemID \(itemID)")
        }
    }
    // Looks to see if there is an existing notification; if there is then it is cancelled. Then determine whether the item should have a notification; if so then schedule a new one.
    
    // Function is only performed if both shouldRemind is true and dueDate > Date
    // Put the item's text into the notification message
    // Extract month, day, hour and minute from the dueDate into a constant called components
    // Show the notification at a specified date (UNCalendarNotificationTrigger)
    // Create a UNNotificationRequest object, using the itemID as a String as an identifier
    // Add the notification to the UNUserNotificationCenter
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    // Removes local notification from the ChecklistItem. N.B. removePendingNotifications requires an array of identifiers.
    
    deinit{
        removeNotification()
    }
    // Invoked when an individual ChecklistItem is deleted, and also when a whole Checklist (containing Checklist Items) are deleted.
}
