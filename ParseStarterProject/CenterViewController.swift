/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class CenterViewController: UIViewController {
  
    
  var menuItem: MenuItem! {
    didSet {
      title = menuItem.title
        navigationController?.navigationBar.barTintColor = menuItem.color
        if menuItem.symbol == "✺" {
            let settingsViewController = SettingsViewController()
//            let curentChildVC = self.presentedViewController
//            print("------>", curentChildVC?.childViewControllers)
            //            let containerVC = curentChildVC?.parentViewController
            //            curentChildVC?.willMoveToParentViewController(nil)
            //            containerVC?.transitionFromViewController(curentChildVC!, toViewController: settingsViewController, duration: 0.5, options: .TransitionCrossDissolve, animations: nil, completion: { (_) in
            //                curentChildVC?.removeFromParentViewController()
            //                settingsViewController.didMoveToParentViewController(containerVC)
            //            })
//            curentChildVC?.removeFromParentViewController()
            addChildViewController(settingsViewController)
            view.addSubview(settingsViewController.view)
            settingsViewController.didMoveToParentViewController(self)
            print("________", childViewControllers)
            
        } else {
            addScanner()
        }
    }
  }
  
//  @IBOutlet var symbol: UILabel!
  
  // MARK: ViewController
  
  var menuButton: MenuButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.tintColor = .whiteColor()
    
    menuButton = MenuButton()
    menuButton.tapHandler = {
      if let containerVC = self.navigationController?.parentViewController as? ContainerViewController {
        containerVC.toggleSideMenu()        
      }
    }
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    menuItem = MenuItem.sharedItems.first!
  }
    func addScanner() {
        let scannerView = ScannerViewController()
        addChildViewController(scannerView)
        view.addSubview(scannerView.view)
        scannerView.didMoveToParentViewController(self)
    }
  
}