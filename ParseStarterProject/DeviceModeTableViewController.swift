//
//  DeviceModeTableViewController.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-19.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class DeviceModeTableViewController: UITableViewController {

    let modesArray : [String] = ["View mode", "Archive mode", "Defrost mode", "Discharge mode"]
    var selectedRow : Int = 0

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modesArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Mode Cell", forIndexPath: indexPath)
        if indexPath.row == selectedRow {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        cell.textLabel?.text = modesArray[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Changing the view mode will erase all the scanned items."
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("Mode Cell", forIndexPath: indexPath)
        cell.accessoryType = .Checkmark
        selectedRow = indexPath.row
        tableView.reloadData()
        if let settingsVC = navigationController?.viewControllers[1] as? SettingsTableViewController {
            settingsVC.index = selectedRow
        }
        if let scannerVC = navigationController?.viewControllers.first as? ScannerViewController {
            scannerVC.scannedItems = []
            scannerVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: modesArray[selectedRow], style:.Plain, target:nil, action:nil)

        }
    }
}
