//
//  ExtraCode.swift
//  Checklists
//
//  Created by Ronald Tong on 24/6/18.
//  Copyright © 2018 StokeDesign Co. All rights reserved.
//

/*
 
 // How to set up object A as a delegate for object B:
 // (1) Define a delegate protocol for object B
 // (2) Give object B a delegate optional variable that is weak
 // (3) Make object B send messages to the delegate when something happens. Use delegate?.methodname(self,...)
 // (4) Declare capability of A to be a delegate; include ...Delegate in the class line
 // (5) Implement delegate methods from the protocol
 // (6) Tell object B that object A is now its delegate using the prepare(for:sender:) method
 
 // How to write an init
 // init() { instance variables and constants
 // super.init()
 // other methods }
 
import Foundation

items = [ChecklistItem]()

// Instantiates the array by using (), items now contains an array object but nothing in the array

//let row0item = ChecklistItem()
//row0item.text = "Walk the dog"
//row0item.checked = false
//items.append(row0item)
// Instantiates the ChecklistItem object (), tells items (array) to append (add) row0item into the array

func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
}

// Construct a path to the file that will store the checklist checklist.items
// default returns a FileManager object, urls returns an array of urls for the specified directory and domainMask. Returns a URL

func saveChecklistItems() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.encode(checklist.items, forKey: "ChecklistItems")
    archiver.finishEncoding()
    data.write(to: dataFilePath(), atomically: true)
}

// NSKeyedArchiver encodes the array into data that can be written to file
// Sends ChecklistItem an "encode(with)" message
// Data is placed in a NSMutableData object, which is then written to a file at dataFilePath

func loadChecklistItems() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        checklist.items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
        unarchiver.finishDecoding()
    }
}

// Puts results of dataFilePath() into a temporary constant called path
// If there is data at the path (ie Checklists.plist file) then try to do the function (otherwise skip the function):
// Tell Unarchiver to decode the stored ChecklistItems.plist into an array

required init?(coder aDecoder: NSCoder) {
    
    // Initializer method. Use when you can't give a variable a value right away when declared
    
    super.init(coder: aDecoder)
    loadChecklistItems()
    
    print("Documents folder is \(documentsDirectory())")
    print("Data file path is \(dataFilePath()))")
}

 For In Loop:
 
 for list in lists {
 let item = ChecklistItem()
 item.text = "Item for \(list.name)"
 list.items.append(item)
 
 For each list in the lists array, create a checklistItem with the text "Item for "listname" and add that to the items array. 
 
 
 Finding Data Path
 required init?(coder aDecoder: NSCoder) {
 . . .
 super.init(coder: aDecoder)

 print("Documents folder is \(documentsDirectory())")
 print("Data file path is \(dataFilePath())")
 }
 
 func saveData() {
 let navigationController = window!.rootViewController as! UINavigationController
 let controller = navigationController.viewControllers[0] as! AllListsViewController
 controller.saveChecklists()
 
 
*/
