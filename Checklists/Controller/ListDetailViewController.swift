//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Ronald Tong on 18/6/18.
//  Copyright © 2018 StokeDesign Co. All rights reserved.
//

import UIKit
protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController,didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController,didFinishEditing checklist: Checklist)
}

    // Declares protocol for the ListDetailViewController Delegate to follow (All Lists View Controller)

class ListDetailViewController: UITableViewController,UITextFieldDelegate, IconPickerViewControllerDelegate {

    // Declares self as the delegate for IconPickerViewController
    
@IBOutlet weak var textField: UITextField!
@IBOutlet weak var doneBarButton: UIBarButtonItem!
@IBOutlet weak var iconImageView: UIImageView!

weak var delegate: ListDetailViewControllerDelegate?
var checklistToEdit: Checklist?
var iconName = "Folder"
    
    // Declares that there is a delegate
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    // If a segue is called with the identifier "PickIcon" then this method is performed
    // Segue destination (which is IconPickerVIewController) is defined as controller. Tell that ViewController that self is the delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
        return nil
        }
    }
    
    // Tells the delegate that a row has been selected (when tap and finger lifts); if the row index is in section 1 then return that indexPath, otherwise do nothing
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
            iconImageView.image = UIImage(named: iconName)
        }
    }
    // If checklistToEdit option is not nil, then change the page title to "Edit Checklist", copy the checklist object's icon name into the icon name instance variable. Then load the icon's image file into a UIImage object
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
        }
        
    @IBAction func done() {
        if let checklist = checklistToEdit {
                checklist.name = textField.text!
            checklist.iconName = iconName
                delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
                delegate?.listDetailViewController(self, didFinishAdding: checklist)
            }
        }
    
    // If there is a checklist to edit then: change the text to the checklist name, change the icon to the checklist Icon. If there is a delegate then send the message that we have finished editing the item checklist
    // If there is no checklist to edit then: create a new checklist object using the Checklist class with the name and icon. If there is a delegate then send the message that we have finished adding.
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
        }
    
    // *** 
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
        
    }
    
    // Delegate function called by IconPickerViewController; defines iconName then tells what image to use for that icon
    // self.iconName is used to be clear which iconName we are referring to (parameter from delegate method or instance variable)
    
    // Use popViewController when using 'show'/push segue style, and dismiss() for modal screens
    // navigationController is an optional property of the view controller so you need to use ? to access the UINavigationController object
    // _ = is a wildcard used in place of a variable name, it tells Xcode the return value doesn't matter
}


