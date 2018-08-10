//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Ronald Tong on 26/6/18.
//  Copyright © 2018 StokeDesign Co. All rights reserved.
//

import UIKit
protocol IconPickerViewControllerDelegate: class {
func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

    // Declares a protocol for the delegate to follow

class IconPickerViewController: UITableViewController {
    
    weak var delegate: IconPickerViewControllerDelegate?
    let icons = ["No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"]
    
    // Declares there is a delegate (weak optional)
    // Create an array of icons containing names of icon images
    
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return icons.count}
    
    // Delegate method asking tableviewcontroller to return the number of rows (equal to the number of icons available)

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
    
    let iconName = icons[indexPath.row]
    cell.textLabel!.text = iconName
    cell.imageView!.image = UIImage(named: iconName)
    
    return cell
    }
    
    // Delegate method asking tableviewcontroller to get a table view cell, then give it text and an image
    // Creates a local variable called iconName that is the object from the given row in the icon array; then gives it the related text property and image property
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
    
    // Calls the delegate method when a row is tapped
    // If there is a delegate then the method is performed; create a local variable called icon name with properties from the icon object from the icons array
    // Tells the delegate to perform the iconPicker function with parameters self and iconName
    
}
