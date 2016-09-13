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
    
    
    var curentUser : CurentUser!
    var scannedItem : ScannedItem!
    
    typealias curentUserStatus = (CurentUser) -> Void
    typealias barcodeCheckStatus = (Bool, String, ScannedItem) -> Void
    typealias loginStatus = (Bool, String, CurentUser) -> Void
    typealias signUpStatus = (Bool, String, CurentUser) -> Void
    typealias logOutStatus = (Bool, String) -> Void
    typealias scannedListUpdateStatus = (Bool, String, Int) -> Void
    
    func checkCurentUserStatus(complition: curentUserStatus) -> Bool {
        curentUser = CurentUser()
        let user = PFUser.currentUser()
        if let username = user?.username {
            curentUser.username = username
            curentUser.firstName = user!.objectForKey("firstName") as! String
            curentUser.lastName = user!.objectForKey("lastName") as! String
            complition(curentUser)
            return true
        } else {
            return false
        }
    }
    
    func loginWithUsernameAndPassword(username: String, password: String, complition : loginStatus) {
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            self.curentUser = CurentUser()
            if error == nil && user?.username != nil {
                self.curentUser.username = user!.username!
                self.curentUser.firstName = user?.objectForKey("firstName") as! String
                self.curentUser.lastName = user?.objectForKey("lastName") as! String
                complition(true, "", self.curentUser)
 
            } else {
                let errorString = error!.userInfo["error"] as! String
                complition(false, errorString, self.curentUser)
            }
        }
    }
    
    func parseSignUpInBackgroundWithBlock(username: String, password: String, firstName: String, lastName: String, email: String, completion: signUpStatus) {
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.email = email
        newUser["firstName"] = firstName
        newUser["lastName"] = lastName
        newUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
            if(error != nil) {
                let errorString = error!.userInfo["error"] as! String
                completion(false, errorString, self.curentUser)
            } else {
                self.curentUser.username = username
                self.curentUser.firstName = firstName
                self.curentUser.lastName = lastName
                completion(true, "", self.curentUser)
            }
        })
    }
    
    func addScannedItemsToDataBase(scannedItemsList: [ScannedItem], completion: scannedListUpdateStatus) {
        var itemSavedSuccessfuly : Bool?
        var returnedError = ""
        var errorAtIndex = 0
        var itemsCount = 0
        var successfulSavedItems = [ScannedItem]()
        for i in 0..<scannedItemsList.count {
            let inventory = PFObject(className:"Inventory")
            inventory["barcode"] = scannedItemsList[i].barcode
            inventory["name"] = scannedItemsList[i].name
            inventory["type"] = scannedItemsList[i].type
            inventory["library"] = scannedItemsList[i].library
            inventory["creatorsUsername"] = scannedItemsList[i].creatorUsername
            inventory["creatorFirstName"] = scannedItemsList[i].creatorFirstName
            inventory["creatorLastName"] = scannedItemsList[i].creatorLastName
            inventory["dateCreated"] = scannedItemsList[i].dateCreated
            inventory["expiryDate"] = scannedItemsList[i].expiryDate
            inventory["dateLastDefrosted"] = scannedItemsList[i].dateLastDefrosted
            inventory["lastDefrostedBy"] = scannedItemsList[i].lastDefrostedBy
            inventory["detailedInformation"] = scannedItemsList[i].detailedInformation
            inventory["project"] = scannedItemsList[i].project
            inventory["numberOfThaws"] = scannedItemsList[i].numberOfThaws
            inventory["plateType"] = scannedItemsList[i].plateType
            inventory["plateStatus"] = scannedItemsList[i].plateStatus
            inventory.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    itemSavedSuccessfuly = true
                    successfulSavedItems.append(scannedItemsList[i])
                    itemsCount += 1
                    completion(itemSavedSuccessfuly!,returnedError, errorAtIndex)
                } else {
                    itemSavedSuccessfuly = false
                    returnedError = error!.userInfo["error"] as! String
                    errorAtIndex = itemsCount
                    completion(itemSavedSuccessfuly!,returnedError, errorAtIndex)
                }
            }
            if itemSavedSuccessfuly == false {
                break
            }
        }
    }
    
    func lookUpBarcode(string : String, completion : barcodeCheckStatus) {
        scannedItem = ScannedItem()
        let query = PFQuery(className: "Inventory")
        query.whereKey("barcode", equalTo: string)
        query.findObjectsInBackgroundWithBlock({ (objects, error) in
            if error == nil {
                if let objects = objects {
                    switch objects.count {
                    case 0:
                        completion(false, "Nothing found", self.scannedItem)
                    case 1:
                        for object in objects {
                            if let barcode = object.valueForKeyPath("barcode") as? String {
                                self.scannedItem.barcode = barcode
                            }
                            if let name = object.valueForKeyPath("name") as? String {
                                self.scannedItem.name = name
                            }
                            if let type = object.valueForKeyPath("type") as? String {
                                self.scannedItem.type = type
                            }
                            if let library = object.valueForKeyPath("library") as? String {
                                self.scannedItem.library = library
                            }
                            if let creatorUsername = object.valueForKeyPath("creatorUsername") as? String {
                                self.scannedItem.creatorUsername = creatorUsername
                            }
                            if let creatorFirstName  = object.valueForKeyPath("creatorFirstName") as? String {
                                self.scannedItem.creatorFirstName = creatorFirstName
                            }
                            if let creatorLastName = object.valueForKeyPath("creatorLastName") as? String {
                                self.scannedItem.creatorLastName = creatorLastName
                            }
                            if let dateCreated = object.valueForKeyPath("dateCreated") as? String {
                                self.scannedItem.dateCreated = dateCreated
                            }
                            if let expiryDate = object.valueForKeyPath("expiryDate") as? String {
                                self.scannedItem.expiryDate = expiryDate
                            }
                            if let dateLastDefrosted = object.valueForKeyPath("dateLastDefrosted") as? String {
                                self.scannedItem.dateLastDefrosted = dateLastDefrosted
                            }
                            if let lastDefrostedBy = object.valueForKeyPath("lastDefrostedBy") as? String {
                                self.scannedItem.lastDefrostedBy = lastDefrostedBy
                            }
                            if let detailedInformation = object.valueForKeyPath("detailedInformation") as? String {
                                self.scannedItem.detailedInformation = detailedInformation
                            }
                            if let project = object.valueForKeyPath("project") as? String {
                                self.scannedItem.project = project
                            }
                            if let numberOfThaws = object.valueForKeyPath("numberOfThaws") as? Int {
                                self.scannedItem.numberOfThaws = numberOfThaws
                            }
                            if let plateType = object.valueForKeyPath("plateType") as? String {
                                self.scannedItem.plateType = plateType
                            }
                            if let plateStatus = object.valueForKeyPath("plateStatus") as? String {
                                self.scannedItem.plateStatus = plateStatus
                            }
                        }
                        completion(true, "Success", self.scannedItem)
                    default:
                        completion(false, "More than one item with the same barcode is in database.", self.scannedItem)
                    }
                }
            } else {
                let errorString = error!.userInfo["error"] as! String
                print("Error: \(error!). " + errorString)
                completion(false, "Didn't find any object", self.scannedItem)
            }
        })
    }
    
    func updateChanges(scannedItemsList: [ScannedItem], defrostingUser : CurentUser) -> [ScannedItem] {
        var unsavedItems = [ScannedItem]()
        for scannedItem in scannedItemsList {
            let query = PFQuery(className: "Inventory")
            query.whereKey("barcode", equalTo: scannedItem.barcode)
            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            object["dateLastDefrosted"] = scannedItem.dateLastDefrosted
                            object["lastDefrostedBy"] = "\(defrostingUser.firstName)  \(defrostingUser.lastName)"
                            object["numberOfThaws"] = scannedItem.numberOfThaws + 1
                            object.saveInBackgroundWithBlock({ (success, error) in
                                if success {
                                    print("Success")
                                } else {
                                    unsavedItems.append(scannedItem)
                                }
                            })
                        }
                    }
                } else {
                    unsavedItems.append(scannedItem)
                    print("Error: \(error!) \(error!.userInfo)")
                }
            })
        }
        return unsavedItems
    }
    
    func logout(completion: logOutStatus) {
        if PFUser.currentUser() != nil {
            PFUser.logOutInBackgroundWithBlock({ (error) in
                if error != nil {
                    let errorString = error!.userInfo["error"] as! String
                    completion(false, errorString)
                } else {
                    completion(true, "")
                }
            })
        }
    }

}

