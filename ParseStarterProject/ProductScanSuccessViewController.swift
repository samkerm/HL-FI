//
//  ProductScanSuccessViewController.swift
//  HL-FI
//
//  Created by Sam Kheirandish on 2016-09-08.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ProductScanSuccessViewController: UIViewController {

    @IBOutlet weak var successfulView: UIView!
    @IBOutlet weak var doneView: UIView!
    var scannedItem : ScannedItem!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfThawsLabel: UILabel!
    @IBOutlet weak var dateLastDefrostedLabel: UILabel!
    @IBOutlet weak var lastDefrostedByLabel: UILabel!
    @IBOutlet weak var creatorsNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var detailedInformationLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var detailedInformationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var successfullViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var successfulViewWidthCostraint: NSLayoutConstraint!
    @IBAction func doneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        adjusTheFrames()
        adjustHeightForContent()
        doneView.layer.cornerRadius = 20
        successfulView.layer.cornerRadius = 20
        if (scannedItem != nil) {
            barcodeLabel.text = scannedItem.barcode
            nameLabel.text = scannedItem.name
            numberOfThawsLabel.text = String(scannedItem.numberOfThaws)
            lastDefrostedByLabel.text = scannedItem.lastDefrostedBy
            dateLastDefrostedLabel.text = scannedItem.dateLastDefrosted
            creatorsNameLabel.text = scannedItem.creatorFirstName + " " + scannedItem.creatorLastName
            dateCreatedLabel.text = scannedItem.dateCreated
            expiryDateLabel.text = scannedItem.expiryDate
            detailedInformationLabel.text = scannedItem.detailedInformation
        }
    }
    func adjusTheFrames() {
        doneViewWidthConstraint.constant = (self.view.frame.size.width > 414) ? 362 : (view.frame.size.width - view.frame.size.width/8)
        successfulViewWidthCostraint.constant = doneViewWidthConstraint.constant
        doneViewVerticalConstraint.constant = self.view.frame.size.height/48
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
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.clearColor()
    }
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: {
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
            }, completion: nil)
        view.layoutIfNeeded()
    }
    override func viewWillDisappear(animated: Bool) {
        self.view.backgroundColor = UIColor.clearColor()
    }
}
