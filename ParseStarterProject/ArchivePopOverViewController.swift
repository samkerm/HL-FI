//
//  ArchivePopOverViewController.swift
//  HL-FI
//
//  Created by Sam Kheirandish on 2016-09-06.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ArchivePopOverViewController: UIViewController {
    @IBOutlet weak var plateNameTextField: UITextField!
    @IBOutlet weak var libraryNameTextField: UITextField!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var additionalInformationTextField: UITextField!
    @IBOutlet weak var datePreparedTextField: UITextField!
    @IBOutlet weak var freezerLocationTextField: UITextField!
    var platePickerView = UIPickerView()
    var freezerLocationPickerView = UIPickerView()
    var freezerLocation = ["F":"", "S":"", "R":""]
    @IBAction func itemTypeChanged(sender: AnyObject) {
        
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDatePreparedTextFieldsInputView()
//        setUpPlateTypeTextFieldsInputView()
        setUpFreezerLocationTextFieldsInputView()
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    func setUpFreezerLocationTextFieldsInputView() {
        freezerLocationPickerView.dataSource = self
        freezerLocationPickerView.delegate = self
        freezerLocationPickerView.frame = CGRectMake(0, 40, view.bounds.width, 100)
        freezerLocationPickerView.tag = 2
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
//    func setUpPlateTypeTextFieldsInputView() {
//        platePickerView.dataSource = self
//        platePickerView.delegate = self
//        platePickerView.frame = CGRectMake(0, 40, view.bounds.width, 100)
//        platePickerView.tag = 1
//        plateTypeTextField.inputView = platePickerView
//    }
    
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
        
        datePreparedTextField.inputView = inputView
        datePickerView.addTarget(self, action: #selector(ArchivePopOverViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePreparedTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneButton(sender:UIButton) {
        datePreparedTextField.resignFirstResponder()
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
        switch pickerView.tag {
        case 1:
            return 1
        default:
            return 3
        }
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return 2
        default:
            switch component {
            case 0:
                return 16
            case 1:
                return 6
            default:
                return 5
            }
        }
        
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            switch row {
            case 0:
                return "384"
            default:
                return "96"
            }
        default:
            switch component {
            case 0:
                return row == 0 ? "Freezer" : "F\(String(format: "%02d", row))"
            case 1:
                return row == 0 ? "Shelf" : "S\(String(format: "%02d", row))"
            default:
                return row == 0 ? "Rack" : "R\(String(format: "%02d", row))"
            }
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1: break
//            switch row {
//            case 0:
//                plateTypeTextField.text = "384"
//            default:
//                plateTypeTextField.text = "96"
//            }
//            plateTypeTextField.resignFirstResponder()
        default:
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
}
