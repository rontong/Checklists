//
//  DataModel.swift
//  Checklists
//
//  Created by Ronald Tong on 24/6/18.
//  Copyright © 2018 StokeDesign Co. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get { return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set { UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    // Computed Property: when trying to read value of indexOfSelectedChecklist the get is performed. When trying to put a new value into this variable, the set is performed.
    // Get: returns an integer for the value stored in dictionary with key ChecklistIndex
    // Set: sets a new value for key "ChecklistIndex" in the dictionary
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // Constructs a path to the file that will store the checklist checklist.items
    // default returns a FileManager object, urls returns an array of urls for the specified directory and domainMask. Returns a URL
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    // NSKeyedArchiver encodes the array into data that can be written to file
    // Data is placed in a NSMutableData object called data, then tells the archiver to encode the lists array (contains Checklists) using the key Checklists. This is then written to a file at dataFilePath
    
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
        
            sortChecklists()
        }
        
    // Puts results of dataFilePath() into a temporary constant called path
    // If there is data at the path (ie Checklists.plist file) then try to do the function (otherwise skip the function):
    // Tell Unarchiver to decode the stored ChecklistItems.plist into an array
    
    }
    
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // Creates a dictionary: ChecklistIndex Key returns an Int -1, FirstTime returns a Bool true, ChecklistItemID returns 0
    // Tells UserDefaults to add contents of the dictionary to the registration domain
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
   
    // Check UserDefault for the "FirstTime" Key. If it is true, then create a new Checklist object and add it to the array.
    // Also sets indexOfSelectedChecklist to 0 to make sure there is a segue to the new list in AllListsViewController
    // FirstTime is then set to false so the code won't be executed again at the next start up
    
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending })
    }
   
    // Tells the lists array to sort by the forumla within the by: {}
    // localizedStandardCompared() method compares the two name strings
    
    class func nextChecklistItemID() -> Int{
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    // Gets the current ChecklistItemID value from User defaults dictionary, adds 1 and writes it back to UserDefaults. The first time it is called it returns ID 0, next time 1 and increases by 1 each time
    // Class method was called as ChecklistItem object that calls this method does not have a dataModel property referring to the DataModel object. Class func allows you to call methods even when you don't have refernce to that object
}
