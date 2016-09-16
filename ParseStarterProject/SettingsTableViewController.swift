//
//  SettingsTableViewController.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-18.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var index: Int = 0 {
        didSet {
            if let scannerVC = navigationController?.viewControllers[0] as? ScannerViewController {
                scannerVC.deviceModeIndex = index
            }
        }
    }
    let modesArray : [String] = ["View mode", "Archive mode", "Defrost mode", "Discharge mode"]
    let parseBackendHandler = ParseBackendHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        navigationController?.hidesBarsOnTap = false
//        let logOut = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: #selector(self.logOut))
//        navigationItem.rightBarButtonItem = logOut
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func logOut() {
        let alertC = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .ActionSheet)
        alertC.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (_) in
            self.parseBackendHandler.logout({ (success, error) in
                if success {
                    let Login = self.storyboard!.instantiateViewControllerWithIdentifier("LoginPage")
                    self.presentViewController(Login, animated: true, completion: nil)
                } else {
                    print(error)
                }
            })
        }))
        alertC.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        presentViewController(alertC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("Settings Cell", forIndexPath: indexPath)
            cell.textLabel!.text = "Device mode"
            cell.detailTextLabel?.text = modesArray[index]
            cell.accessoryType = .DisclosureIndicator
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("Settings Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "About"
            cell.accessoryType = .DetailButton
            cell.detailTextLabel?.text = ""
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Logout Cell", forIndexPath: indexPath)
            let frame = CGRect(x: 0.0, y: 0.0, width: cell.frame.width, height: cell.frame.height)
            let logoutButton = UIButton()
            logoutButton.frame = frame
            logoutButton.setTitle("Logout", forState: .Normal)
            logoutButton.setTitleColor(.lightGrayColor(), forState: .Highlighted)
            logoutButton.addTarget(self, action: #selector(self.logOut), forControlEvents: .TouchUpInside)
            cell.contentView.backgroundColor = .redColor()
            cell.contentView.addSubview(logoutButton)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Set the \"Device mode\" to the state of the app for managing the content."
        }
        return "Created by Sam Kheirandish. Copyright © 2016 UBC. All rights reserved."
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0 {
            return ""
        }
        return "Information handler"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegueWithIdentifier("Show Settings Detail", sender: self)
        } else {
            performSegueWithIdentifier("ShowAbout", sender: self)
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Settings Detail" {
            let destinationVC = segue.destinationViewController as! DeviceModeTableViewController
            destinationVC.selectedRow = index
        }
    }

}
