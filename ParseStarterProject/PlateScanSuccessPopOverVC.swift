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
    @IBOutlet weak var plateNameLabel: UILabel!
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var numberOfThawsLabel: UILabel!
    @IBOutlet weak var dateLastDefrostedLabel: UILabel!
    @IBOutlet weak var lastDefrostedByLabel: UILabel!
    @IBOutlet weak var creatorsNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var detailedInformationLabel: UILabel!
    @IBOutlet weak var successfullViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailedInformationHeightConstraint: NSLayoutConstraint!
    @IBAction func doneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doneView.layer.cornerRadius = 20
        successfulView.layer.cornerRadius = 20
        if (scannedItem != nil) {
            barcodeLabel.text = scannedItem.barcode
            plateNameLabel.text = scannedItem.name
            libraryNameLabel.text = scannedItem.library
            projectNameLabel.text = scannedItem.project
            numberOfThawsLabel.text = String(scannedItem.numberOfThaws)
            dateLastDefrostedLabel.text = scannedItem.dateLastDefrosted
            lastDefrostedByLabel.text = scannedItem.lastDefrostedBy
            creatorsNameLabel.text = scannedItem.creatorFirstName + " " + scannedItem.creatorLastName
            dateCreatedLabel.text = scannedItem.dateCreated
            detailedInformationLabel.text = scannedItem.detailedInformation
            adjustHeightForContent()
        }
    }
    
    func adjustHeightForContent() {
        let initialConstraint = detailedInformationHeightConstraint.constant
        var newConstraint : CGFloat
        let numberOfCharacters = CGFloat((detailedInformationLabel.text?.characters.count)!)
        let constant : CGFloat = numberOfCharacters / 2.5
        let remainder : CGFloat = constant % 16
        if remainder == 0 {
            newConstraint = constant
        } else {
            newConstraint = constant + (16 - remainder)
        }
        let differenceInConstraints = newConstraint - initialConstraint
        if differenceInConstraints < 0.0 {
            detailedInformationHeightConstraint.constant += differenceInConstraints
            successfullViewHeightConstraint.constant += differenceInConstraints
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
