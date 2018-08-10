//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Ronald Tong on 14/6/18.
//  Copyright © 2018 StokeDesign Co. All rights reserved.
//

import Foundation
import UserNotifications 
import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistItem)
}

    // Protocol doesn't implement any methods, just says an object that conforms to this protocol must implement X, Y and Z
    // (1; Defines the delegate protocol for object B (ItemDetailViewController)

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    // Declares that ItemDetailViewController is a delegate for UITableView and UITextField
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    // Delegates are usually declared weak and optional. In this case when ItemDetailViewController is loaded, it won't know who it's delegate is and thus must be optional (2; Give object B a delegate optional variable that is weak)
    // delegate?.itemDetailViewControllerDidCancel(self) is shorthand for when the delegate is not set
    
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // Tells textField to become the first responder (keyboard will come up first)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    // When itemToEdit is not nil (ie. there is an existing ChecklistItem), the title is changed to "Edit Item". Otherwise when there is no existing item then the title is not changed
    // if let temporaryConstant = optionalVariable{}. Use if let to unwrap an optional. If the optional is not nil then the code is performed
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // TableViewDelegate method. When the user taps a cell, tableView sends the delegate a message saying "I am about to select this row"
    // Return nil means the delegate answers back "Sorry you are not allowed to" and disables the cell highlight
    // When returning a value, it must be of the data type specified after the ->
    // ? or ! tells Swift that you can return a nil value
    
    override func tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //if indexPath.section == 1 && indexPath.row == 2
        if indexPath == IndexPath(row: 2, section: 1)
        {
            return 217
        } else { return super.tableView(tableView, heightForRowAt: indexPath)}
    }
    
    // Asks delegate for the height to use for a row in a specified location
    // If the row is number 2 in section 1 then make cell height 217 points (UIDatePicker is 216 points tall with 1 point for separator line)
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
        return 3
     } else {
        return super.tableView(tableView, numberOfRowsInSection: section)
        }
     }
    
    // Tableview asks delegate for the number of rows in a section. If the date picker is visible then section 1 has 3 roww. If date picker isn't visible then pass through to the original data source
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //if indexPath.section == 1 && indexPath.row == 2 //
        if indexPath == IndexPath(row: 2, section: 1){
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
 
    // Overrides data source for a static table view. If cellForRowAt is being called with an indexpath of the date picker row, return the datePickerCell.
    // Otherwise if indexpath is not the date picker row, method calls super (UITableViewController)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        //if indexPath.section == 1 && indexPath.row == 1 {
        if indexPath == IndexPath(row: 1, section: 1) {
            if !datePickerVisible {
            showDatePicker()
            } else {
            hideDatePicker()
        }
    }
    }
    // When index path indicates the due date row was tapped (Section 1 Row 1), showDatePicker method is called
    // Allows toggle between visible and hidden states of the date picker
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        //if indexPath.section == 1 && indexPath.row == 2 {newIndexPath = IndexPath(row: 0, section: indexPath.section)
        if indexPath == IndexPath(row: 2, section: 1){ newIndexPath = IndexPath(row:0, section: indexPath.section)
    }
        return super.tableView(tableView,indentationLevelForRowAt: newIndexPath)
    }
    // Tricks data source to believe there are 3 rows in the section where date picker is visible (Date picker cell isn't part of the tableview on storyboard)
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
            as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    // UITextFIeld delegate method, invoked every time a user changes the text
    // textField tells the delegate that the text has been changed, defines the part that should be replaced and the string to replace it with (doesn't provide new text)
    // Declares oldText as the NSString in textField (now linked to UI)
    // Declares newText to be: tells oldText to return a string where the characters have been replaced
    // if newText.length > 0 then doneBarButton is enabled, otherwise it is not
    // Use = in the place of if statements. If some condition {something = true} else {something = false} can be written as something = (some condition)
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    // Sends messages to the delegate when the cancel button is pressed
    // Is there a delegate? If so then send the itemDetailViewControllerDidCancel message
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: item)
            
        } else {
            
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
            
        }
        
    // (3) Sends message to the delegate when done button is pressed
    // If itemToEdit contains an object then the function is performed; text from textfield is put into the ChecklistItem object and a delegate method is called
    // Tells item (ChecklistItem object) to perform the scheduleNotification function
    
    // If there is no itemToEdit: instantiate a local variable item based off ChecklistItem class. The text, checked, reminder, and due date properties are included
    // If there is a delegate, send the didFinishAdding message to the ItemDetailViewControllerDelegate (containing properties as a parameter)
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    // Updates the dueDate variable with the new date, then updates the label
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in /* do nothing */
            }
        }
    }
    
    // When switch is toggled on, the user is prompted for permission to send local notifications. Once the user has given permission the app won't put up a prompt again.
    
  func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    // DateFormatter converts date value to text

    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    // Sets the datePicker variable to true
    // If cellForRow is not nil, then the detailTextLabel text colour is made the tint colour
    // Tells tableView to insert a row below the due date cell and then reload the due date row
    // As tableview is doing two operations at the same time (new row and reload) it has to be put between calls beginUpdates() and endUpdates(); this allows everything to be animated simultaneously
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    // Opposite of showDatePicker: deletes the date picker cell from tableView and restores color of text to grey
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
}
