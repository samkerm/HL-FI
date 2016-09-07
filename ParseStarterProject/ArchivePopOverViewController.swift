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
    @IBOutlet weak var plateTypeTextField: UITextField!
    @IBOutlet weak var freezerLocationTextField: UITextField!
    @IBOutlet weak var originalReplicateTextField: UITextField!
    @IBAction func itemTypeChanged(sender: AnyObject) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func doneButton(sender:UIButton)
    {
        datePreparedTextField.resignFirstResponder() // To resign the inputView on clicking done.
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
