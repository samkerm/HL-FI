//
//  ListTableViewController.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-17.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    var scannedItems = [ScannedItem]()
    var deviceModeIndex : Int!
    var selectedRow = 0
    let parseHandler = ParseBackendHandler()
    var curentUser : CurentUser!
    
    override func viewWillAppear(animated: Bool) {
        updateLeftBarButtonItem()
        navigationController?.hidesBarsOnTap = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        let send = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(self.submitListWithAllChanges))
        let save = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(self.submitListWithAllChanges))
        if deviceModeIndex == 1 {
            navigationItem.leftBarButtonItem = save
        } else if deviceModeIndex == 2 {
            navigationItem.leftBarButtonItem = send
        }
        let add : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 4)!, target: self, action: #selector (self.pop))
        navigationItem.rightBarButtonItem = add
    }
    func pop() {
        if let scannerCV = navigationController?.viewControllers[0] as? ScannerViewController {
            scannerCV.scannedItems = scannedItems
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    func updateLeftBarButtonItem() {
        if scannedItems.count == 0 {
            navigationItem.leftBarButtonItem?.enabled = false
        } else {
            navigationItem.leftBarButtonItem?.enabled = true
        }
    }
    func submitListWithAllChanges() {
        if deviceModeIndex == 2 {
            let ac = UIAlertController(title: "Update Changes?", message: "Are you sure you want to update these chagnes to the database?", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (_) in
                self.scannedItems = self.parseHandler.updateChanges(self.scannedItems, defrostingUser: self.curentUser)
                self.tableView.reloadData()
                self.updateLeftBarButtonItem()
            }))
            presentViewController(ac, animated: true, completion: nil)
        } else if deviceModeIndex == 1 {
            let ac = UIAlertController(title: "Archive?", message: "Are you sure you want to add this list of barcodes to the database?", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (_) in
                self.parseHandler.addScannedItemsToDataBase(self.scannedItems, completion: { (success, error, index) in
                    if success && index == 0 {
                        self.scannedItems.removeAll()
                        self.tableView.reloadData()
                        self.updateLeftBarButtonItem()
                    } else {
                        print("Found error saving \(self.scannedItems[index]). All items before this have been saved. \(error).")
                        for i in 0..<index {
                            self.scannedItems.removeAtIndex(i)
                        }
                        self.tableView.reloadData()
                        self.updateLeftBarButtonItem()
                    }
                })
            }))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scannedItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("List Cell", forIndexPath: indexPath)
        cell.textLabel!.text = scannedItems[indexPath.row].barcode
        cell.detailTextLabel?.text = scannedItems[indexPath.row].plateName
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Items in this page are editable. Please go through all items before submitting changes"
        }
        return "Ready to commit changes?"
    }
 
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0 {
            return ""
        }
        return "SCANNED ITEMS"
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            scannedItems.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.updateLeftBarButtonItem()
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        performSegueWithIdentifier("Scanned Items Details", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Scanned Items Details" {
            if let destinationVC = segue.destinationViewController as? DetailsOfItemsTableViewController {
                destinationVC.scannedItem = self.scannedItems[selectedRow]
            }
        } else {
            if let destinationVC = segue.destinationViewController as? ScannerViewController {
                destinationVC.scannedItems = self.scannedItems
            }
        }
    }
 
    
}