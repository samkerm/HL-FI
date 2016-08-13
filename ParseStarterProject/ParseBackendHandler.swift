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

}

