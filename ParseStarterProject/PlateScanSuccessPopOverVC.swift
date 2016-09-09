//
//  ScanSuccessPopOverVC.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-21.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class PlateScanSuccessPopOverVC: UIViewController {

    @IBOutlet weak var successfulView: UIView!
    @IBOutlet weak var doneView: UIView!
    var scannedItem : ScannedItem!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var numberOfThawsLabel: UILabel!
    @IBOutlet weak var dateLastDefrostedLabel: UILabel!
    @IBOutlet weak var lastDefrostedByLabel: UILabel!
    @IBOutlet weak var creatorsNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var detailedInformationLabel: UILabel!
    
    @IBAction func doneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doneView.layer.cornerRadius = 20
        successfulView.layer.cornerRadius = 20
        if (scannedItem != nil) {
            barcodeLabel.text = scannedItem.barcode
            nameLabel.text = scannedItem.name
            libraryNameLabel.text = scannedItem.library
            projectNameLabel.text = scannedItem.project
            nameLabel.text = scannedItem.name
            numberOfThawsLabel.text = String(scannedItem.numberOfThaws)
            dateLastDefrostedLabel.text = scannedItem.dateLastDefrosted
            lastDefrostedByLabel.text = scannedItem.lastDefrostedBy
            creatorsNameLabel.text = scannedItem.creatorFirstName + " " + scannedItem.creatorLastName
            dateCreatedLabel.text = scannedItem.dateCreated
            detailedInformationLabel.text = scannedItem.detailedInformation
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
    }
}
