//
//  DetailsOfItemsTableViewController.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-20.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class DetailsOfItemsTableViewController: UITableViewController {

    var contentArray :[AnyObject] = []
    var titleArray = [""]
    var scannedItem = ScannedItem() {
        didSet{
            if scannedItem.type == "Plate" {
                titleArray = ["Barcode","Type", "Name", "PlateType", "Plate Status", "Project", "Library Name", "Creator's Username", "Creator's First Name", "Creator's Last Name", "Date Created", "Last Defrosted By", "Date Last Defrosted", "NumberOf Thaws", "Detailed Information"]
                contentArray.append(scannedItem.barcode)
                contentArray.append(scannedItem.type)
                contentArray.append(scannedItem.name)
                contentArray.append(scannedItem.plateType)
                contentArray.append(scannedItem.plateStatus)
                contentArray.append(scannedItem.project)
                contentArray.append(scannedItem.library)
                contentArray.append(scannedItem.creatorUsername)
                contentArray.append(scannedItem.creatorFirstName)
                contentArray.append(scannedItem.creatorLastName)
                contentArray.append(scannedItem.dateCreated)
                contentArray.append(scannedItem.lastDefrostedBy)
                contentArray.append(scannedItem.dateLastDefrosted)
                contentArray.append(scannedItem.numberOfThaws)
                contentArray.append(scannedItem.detailedInformation)
            } else {
                titleArray = ["Barcode","Type", "Name", "Creator's Username", "Creator's First Name", "Creator's Last Name", "Date Created", "Expiry Date", "Last Defrosted By", "Date Last Defrosted", "NumberOf Thaws", "Detailed Information"]
                contentArray.append(scannedItem.barcode)
                contentArray.append(scannedItem.type)
                contentArray.append(scannedItem.name)
                contentArray.append(scannedItem.creatorUsername)
                contentArray.append(scannedItem.creatorFirstName)
                contentArray.append(scannedItem.creatorLastName)
                contentArray.append(scannedItem.dateCreated)
                contentArray.append(scannedItem.expiryDate)
                contentArray.append(scannedItem.lastDefrostedBy)
                contentArray.append(scannedItem.dateLastDefrosted)
                contentArray.append(scannedItem.numberOfThaws)
                contentArray.append(scannedItem.detailedInformation)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        
    }

    override func viewDidDisappear(animated: Bool) {
        contentArray = []
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Detail", forIndexPath: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.detailTextLabel!.text = String(contentArray[indexPath.row])
        return cell
    }
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let deviceScale = Int(view.bounds.size.width / 320 * 88)
        var charactersCount = 0
        if contentArray[indexPath.row] is String {
            let string = contentArray[indexPath.row] as! String
            charactersCount = string.characters.count
        }
        let scale = CGFloat(charactersCount / deviceScale)
        return (scale * 44) + 44
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
