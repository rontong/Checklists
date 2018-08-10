//
//  Checklist.swift
//  Checklists
//
//  Created by Ronald Tong on 18/6/18.
//  Copyright © 2018 StokeDesign Co. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    
    // There are three init methods: one for when there is just a name, one for then there is a name and an icon, and one to load objects from the plist file
    // convenience init: convenience initializer. Does the same thing as init(name, iconName) but saves from typing "No Icon" when it is used. Conenivence init calls init(name, iconName) with "No Icon" as the iconName parameter 
    // Designated Initializer: init(name, iconName) is the primary way to create new Checklist objects

    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }

    // NSCoding protocol requires adding two methods the init?(code) and encode(with). These load and save Checklist names and item properties
    
    func countUncheckedItems() -> Int {
    var count = 0
    for item in items where !item.checked {
    count += 1
    }
    return count
}
    // Returns the number of unchecked items.
    //For-in-loop: loops through checklistitem objects in the items array, if an object is not checked (!item.checked) then add to the count by 1 (+= means count + 1)
    
}
