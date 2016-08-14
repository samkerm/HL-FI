//
//  SettingsViewController.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-13.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

//    @IBOutlet weak var detailsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let detailsView: UIView = UIView(frame: CGRect(x: 20, y: (navigationController?.navigationBar.bounds.height)! + 40, width: view.bounds.width - 40, height: view.bounds.height - (navigationController?.navigationBar.bounds.height)! - 60))
        detailsView.layer.cornerRadius = 25
        detailsView.layer.backgroundColor = UIColor(red: 89/255, green: 113/255, blue: 85/255, alpha: 1.0).CGColor
        view.addSubview(detailsView)
        // Do any additional setup after loading the view.
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
