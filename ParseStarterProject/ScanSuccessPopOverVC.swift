//
//  ScanSuccessPopOverVC.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-21.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ScanSuccessPopOverVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var frame = textField.frame
        frame.size.height = 100
        textField.frame = frame
        
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
