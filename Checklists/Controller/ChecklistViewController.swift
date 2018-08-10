//
//  Checklists
//
//  Created by Ronald Tong on 14/6/18.
//  Copyright © 2018 StokeDesign Co. All rights reserved.
//

// Review from p145 onwards

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    // ViewController is of type UITableViewController and is declared ItemDetailViewControllerDelegate (4; conforms to delegate protocol)
    // TableView always has two delegates; UITableViewDataSource (putting rows in) and UITableViewDelegate (row taps)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
    // Called when a segue is about to be performed; method only performed if the segue identifier is "AddItem"
    // Finds the UINavigationController object (segue destination) then finds the topViewController (Screen active in Nav Controller). TopView is ItemDetailViewController
    // Tells ItemDetailViewController that their delegate is ChecklistViewController (4; tells object B that object A is now the delegate)

        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    // Tells ItemDetailViewController that ChecklistViewController is now its delegate
    // Return type for indexPath(for) method is an optional IndexPath?, so use if let to unwrap it
    // Tell tableView to return an indexPath for the cell that sent the message (eg. tableview cell disclosure button that was tapped)
    // Tell controller to find the ChecklistItem to edit in the array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    // ChecklistViewController is the datasource, Parameter 1 is the UITableView object on whose behalf the method is invoked, _ removes the external name, Parameter 2 is calling the method (external parameter name), -> means return function, have to use the return phrase
    // tableView asks the data source to return the number of rows as an integer
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem", for: indexPath)
       
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
        
    }
    // tableView asks the data source for a cell to insert on the UITableView. Returns a cell to the tableView
    // When calling a method always include external parameter names (ie. for and with)
    // Tells TableView to find a cell available called ChecklistItem at a particular indexPath
    // To ask for an array item use "array[0]"
    // Finds the object in the array (checklist.items) at a certain row
    // Perform the configureText and configureCheckmark functions, then return all this information to the TableView as a cell
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // TableViewDelegate method, called whenever a user taps on a cell
    // If cellForRow is performed at a given row, then create a variable item using the object in the items array in the checklist
    // Toggle the checkmark, then configure the checkmark
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
       tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // TableView asks the data source to insert or delete a row when tapped by the user, at a specified indexpath row
    // Tells the checklist.items array to remove a ChecklistItem data at a given row
    // Declares a temporary array of indexPaths, then tells tableView to delete rows from the View as well
    
    var checklist: Checklist!
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "☑️"
        } else {
            label.text = ""
        }
    }
    
    // TableView finds the object with tag 1000 that is a UI Label
    // If the ChecklistItem checked is true then label.text is tick. Otherwise it is empty
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = item.text
        //label.text = "\(item.itemID): \(item.text)" Only use for debugging.
    }
    
    // TableView find the object with tag 1000 that is a UILabel
    // The text of this cell will be the text of the item, where item is the ChecklistItem from the array at a given row
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
       
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    // Performs the didFinishAdding method defined by the ItemDetailViewController delegate protocol. (5; implements delegate methods)
    // Adds both new data and a new UI tableview Row
    
    // Declares the new row number for the item added, then adds that item to the array
    // Declares the new index path to be that of the new row, creates a temporary array for the one-index path item (as the insertRows method allows you to insert multiple rows) then tells tableView to insert a row at the given indexPaths
    // Always remember to insert rows to the data model and tableview; checklist.items.append(item) adds the data, tableView.insertRows adds new rows to tableview
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)    
    }

    // Performs the didFinishEditing method defined by the ItemDetailViewController delegate protocol (5)
    // Looks for a cell corresponding with the ChecklistItem object, then configures the text

}

