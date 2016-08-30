//
//  ParseBackendHandler.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-05.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ParseBackendHandler: NSObject {
    
    var barcodeText: String?
    var scannedItem : ScannedItem!
    typealias loginStatus = (Bool, String) -> Void
    typealias signUpStatus = (Bool, String) -> Void
    
    func checkCurentUserStatus() -> Bool {
        let curentUser = PFUser.currentUser()?.username
        if curentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func loginWithUsernameAndPassword(username: String, password: String, complition : loginStatus) {
        print("Loging in...")
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                complition(true, "")
            } else {
                let errorString = error!.userInfo["error"] as! String
                complition(false, errorString)
            }
        }
    }
    
    func parseSignUpInBackgroundWithBlock(username: String, password: String, firstName: String, lastName: String, email: String, completion: signUpStatus) {
        print("Signing up...")
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.email = email
        newUser["firstName"] = firstName
        newUser["lastName"] = lastName
        newUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
            if(error != nil) {
                let errorString = error!.userInfo["error"] as! String
                completion(false, errorString)
            } else {
                completion(true, "")
            }
        })
    }
    
    func searchBackendDataAnalysis(barcodeText:String)  {
        
        let query = PFQuery(className:"Inventory")
        query.whereKey("Barcode", equalTo:"\(barcodeText)")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func addScannedItemsToDataBase(scannedItemsList: [ScannedItem]) {
//        let item = PFObject(className:"Inventory")
//        item["barcode"] = barcodeText
//        item["sampleType"] = "Plate"
//        let timeStamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
//        print(timeStamp)
//        item["date"] = timeStamp
//        item.saveInBackgroundWithBlock {
//            (success: Bool, error: NSError?) -> Void in
//            if (success) {
//                // The object has been saved.
//            } else {
//                // There was a problem, check error.description
//            }
//        }
        print("Uploading List...")
    }
    
    func lookUpBarcode(barcode : String) -> ScannedItem {
        scannedItem = ScannedItem()
        scannedItem.barcode = "\(barcode)"
        scannedItem.creatorFirstName = "Keith"
        scannedItem.creatorLastName = "Mewis"
        scannedItem.creatorUsername = "Namak"
        scannedItem.dateCreated = "Aug-2016"
        scannedItem.dateLastDefrosted = "12-Aug-2016"
        scannedItem.detailedInformation = "Selection of positive clones from mixec CMU-assay for both 1hr and 18hr and when it was replicated there were some cross contamination due to condensations on the lid which dropped down on to the plate"
        scannedItem.lastDefrostedBy = "Keith Miewis"
        scannedItem.library = "CO182"
        scannedItem.plateName = "CO182-01"
        scannedItem.project = "Hydrocarbon"
        scannedItem.numberOfThaws = 3
        return scannedItem
    }
    
    func updateChanges(scannedItemsList: [ScannedItem]) {
        print("Updating List...")
    }
    
    func logout() {
        if PFUser.currentUser() != nil {
            PFUser.logOutInBackground()
        }
    }

}

