//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Ronald Tong on 18/6/18.
//  Copyright © 2018 StokeDesign Co. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    // Declares self as delegate for ListDetailViewController

    var dataModel: DataModel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // Delete functionality. Tells dataModel to find the array and remove data at a given row. Then creates an array of indexPaths and tells the view to delete rows at those paths

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    // TableView Delegate Method (AllListView is the delegate). Invoked when a row is tapped; a segue is performed with checklist object as the parameter (to send data between controllers)
    // Tells the dataModel to perform the indexOfSelectedChecklist function. This sets the ChecklistIndex in the dictionary to the newly selected IndexPath (row selected)
    // Creates a local variable called checklist using the object at datamodel's array called lists at the given row.
    // Segue is performed with identifier "ShowChecklist" using the parameter checklist (create as a variable previously). This is the segue from AllLists to ChecklistViewController.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        
        } else if segue.identifier == "AddChecklist" {
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    // Prepares for a segue from AllListsViewController to Checklist View Controller, or AllListsViewController to ListDetailViewController
    // If ShowChecklist Segue: Declares the controller as the segue destination, then tells the controller that their checklist object references the Checklist object that was included in the sender parameter
    // checklist property is declared Checklist! as it has temporary nil value until viewDidLoad() happens
    
    // If AddChecklist Segue: declare the segue destination to be the navigationController, then finds the topView controller which is ListDetailView.
    // Tells the controller that AllListsViewController is the delegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // Tells tableView to reload all contents and do the tableView(cellForRowAt) again. This is called just before viewDidAppear happens, thus updates all table cells
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
        
        // ViewController makes itself delegate for the navigation controller
        // Tells dataModel to run the computed property indexOfSelectedChecklist (get function). This returns an integer of the selected checklistIndex
        // If the index is valid (between 0 and number of checklists in the datamodel) then the segue is performed with the checklistobject included in the parameter (to send data). This opens up the most recently used checklist
        // If the index is -1 or invalid, then no segue is performed and user stays on AllListsView
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        cell.textLabel!.text = "List\(indexPath.row)"
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else
        if count == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(count) Items Remaining"}
        
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        return cell
    }
    
    // ! are required as textLabel and detailTextLabel are optionals. Can also use if let as a safer alternative (if let label = cell.textLabel{label.text = String
    // Performs the makeCell function with tableView as a parameter. Then creates a local constant checklist referencing the Checklist object in the array at a given row. This checklist is given text and an accessory type
    // Tells checklist to run the countUncheckedItems function, which returns an Integer
    // If the total number of checklist items is 0 then display 'No Items', if the number of unchecked items is 0 then 'All Done'
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
        
    func makeCell(for tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
            } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    // Creates a cell for the TableView

    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
   
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // Implements the delegate methods from ListDetailViewController.
    // Adding: Tells dataModel to add the checklist to the lists array, then sort checklists (using dataModel function) and reload the data
    // Editing: Tells dataModel to sort checklist then reload data 
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
        
    // Method called whenever navigation controller slides to a new screen. If back button pressed to go to AlllListViewController (self), ChecklistIndex value is now -1 meaning no checklist is selected
    // Look at the dataModel (which is based off the DataModel class), and use the indexOfSelectedChecklist variable
        
    }
}
