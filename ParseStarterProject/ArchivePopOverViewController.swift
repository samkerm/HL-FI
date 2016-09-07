//
//  ArchivePopOverViewController.swift
//  HL-FI
//
//  Created by Sam Kheirandish on 2016-09-06.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ArchivePopOverViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var libraryNameTextField: UITextField!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var additionalInformationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var freezerLocationTextField: UITextField!
    var platePickerView = UIPickerView()
    var freezerLocationPickerView = UIPickerView()
    var freezerLocation = ["F":"", "S":"", "R":""]
    var plateState = true
    @IBOutlet weak var itemType: UISegmentedControl!
    @IBOutlet weak var plateType: UISegmentedControl!
    @IBOutlet weak var plateCondition: UISegmentedControl!
    @IBAction func itemTypeChanged(sender: AnyObject) {
        if itemType.selectedSegmentIndex == 0 {
            showPlatelayout()
            plateState = true
        } else {
            showProductLayout()
            plateState = false
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemsDetailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionalInformationVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var freezerLocationVerticalSpacingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDatePreparedTextFieldsInputView()
        setUpFreezerLocationTextFieldsInputView()
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    func showPlatelayout() {
        UIView.animateWithDuration(1.0) {
            self.libraryNameTextField.alpha = 1
            self.projectNameTextField.alpha = 1
            self.plateType.alpha = 1
            self.plateCondition.alpha = 1
            self.nameTextField.placeholder = "Plate Name > 4 characters"
            self.dateTextField.placeholder = "Date Prepared"
            self.containerViewHeightConstraint.constant = 430
            self.itemsDetailsHeightConstraint.constant = 360
            self.additionalInformationVerticalSpacingConstraint.constant = 75
            self.freezerLocationVerticalSpacingConstraint.constant = 75
            self.view.layoutIfNeeded()
        }
    }
    func showProductLayout() {
        UIView.animateWithDuration(1.0) {
            self.libraryNameTextField.alpha = 0
            self.projectNameTextField.alpha = 0
            self.plateType.alpha = 0
            self.plateCondition.alpha = 0
            self.nameTextField.placeholder = "Product Name"
            self.dateTextField.placeholder = "Expiery Date"
            self.containerViewHeightConstraint.constant = 245
            self.itemsDetailsHeightConstraint.constant = 175
            self.additionalInformationVerticalSpacingConstraint.constant = 5
            self.freezerLocationVerticalSpacingConstraint.constant = 5
            self.view.layoutIfNeeded()
            
        }
    }
    func setUpFreezerLocationTextFieldsInputView() {
        freezerLocationPickerView.dataSource = self
        freezerLocationPickerView.delegate = self
        freezerLocationPickerView.frame = CGRectMake(0, 40, view.bounds.width, 100)
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 140))
        inputView.backgroundColor = .lightGrayColor()
        
        inputView.addSubview(freezerLocationPickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRectMake(0, 0, view.bounds.width, 40))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(ArchivePopOverViewController.freezerLocationPickerViewDoneButton(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        freezerLocationTextField.inputView = inputView
    }
    
    func setUpDatePreparedTextFieldsInputView() {
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 140))
        inputView.backgroundColor = .lightGrayColor()
        let datePickerView:UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, view.bounds.width, 100))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRectMake(0, 0, view.bounds.width, 40))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(ArchivePopOverViewController.doneButton(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        dateTextField.inputView = inputView
        datePickerView.addTarget(self, action: #selector(ArchivePopOverViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneButton(sender:UIButton) {
        dateTextField.resignFirstResponder()
    }
    
    func freezerLocationPickerViewDoneButton(sender:UIButton) {
        if freezerLocation["F"] != "" && freezerLocation["S"] != "" && freezerLocation["R"] != "" {
            freezerLocationTextField.text = freezerLocation["F"]!+freezerLocation["S"]!+freezerLocation["R"]!
        }
        freezerLocationTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ArchivePopOverViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 16
        case 1:
            return 6
        default:
            return 5
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return row == 0 ? "Freezer" : "F\(String(format: "%02d", row))"
        case 1:
            return row == 0 ? "Shelf" : "S\(String(format: "%02d", row))"
        default:
            return row == 0 ? "Rack" : "R\(String(format: "%02d", row))"
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            switch component {
            case 0:
                freezerLocation.updateValue("F\(String(format: "%02d", row))", forKey: "F")
            case 1:
                freezerLocation.updateValue("S\(String(format: "%02d", row))", forKey: "S")
            default:
                freezerLocation.updateValue("R\(String(format: "%02d", row))", forKey: "R")
            }
        }
    }
}
