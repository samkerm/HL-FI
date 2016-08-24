//
//  ParseBackendHandler.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-05.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Parse

class ParseBackendHandler: NSObject {
    
    var barcodeText: String?
    var scannedItem : ScannedItem!
    
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
    
    func addBarcodeToDataBase(barcodeText:String) {
        let item = PFObject(className:"Inventory")
        item["barcode"] = barcodeText
        item["sampleType"] = "Plate"
        let timeStamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        print(timeStamp)
        item["date"] = timeStamp
//        item.saveInBackgroundWithBlock {
//            (success: Bool, error: NSError?) -> Void in
//            if (success) {
//                // The object has been saved.
//            } else {
//                // There was a problem, check error.description
//            }
//        }
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

}

