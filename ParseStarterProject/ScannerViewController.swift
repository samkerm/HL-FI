//
//  ViewController.swift
//  HL Barcode Scanner
//
//  Created by Sam Kheirandish on 2016-07-28.
//  Copyright © 2016 Sam Kheirandish. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoOrientation : AVCaptureVideoOrientation!
    let metadataOutput = AVCaptureMetadataOutput()
    let parseBackendHandler = ParseBackendHandler()
    var captureButton = UIButton()
    var deviceModeIndex = 0
    let modesArray : [String] = ["View mode", "Archive mode", "Defrost mode"]
    var scannedItem : ScannedItem!
    var scannedItems = [ScannedItem]()
    var curentUser = CurentUser()
    let dimmedView = UIView()
    
//-------------------------------------------------------------------------------------------------------------
//      MARK: APEARANCE
//-------------------------------------------------------------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.hidesBarsOnTap = true
        navigationItem.title = modesArray[deviceModeIndex]
        switch deviceModeIndex {
        case 0:
            navigationItem.leftBarButtonItem?.enabled = false
        case 1:
            navigationItem.leftBarButtonItem?.enabled = true
        default:
            navigationItem.leftBarButtonItem?.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        addPreviewLayer()
        addCaptureButton()
        drawTargetRectangle()
        initialInstructions()
//        addQuickSwitch()
        let leftPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ScannerViewController.leftSlide))
        leftPan.edges = .Left
        self.view.addGestureRecognizer(leftPan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    
    func drawTargetRectangle() {
        let square = CGRect(x: view.frame.width/2 - 75, y: view.frame.height/2 - 75, width: 150, height: 150)
        let rectangle = CGRect(x: 10, y: view.frame.height/2 - 40, width: view.frame.width - 20, height: 80)
        let pathS = UIBezierPath(rect: square)
        let shapeS = CAShapeLayer()
        let hamburger = UIImage(named: "menu")
        let hamburgerView = UIImageView(image: hamburger)
        hamburgerView.frame = CGRect(x: self.view.bounds.width - hamburgerView.frame.width - 15, y: 30, width: hamburgerView.frame.width, height: hamburgerView.frame.height)
        shapeS.path = pathS.CGPath
        shapeS.lineWidth = 2
        shapeS.lineDashPattern = [4,10,1,2]
        shapeS.strokeColor = UIColor.redColor().CGColor
        shapeS.fillColor = UIColor.clearColor().CGColor
        let pathR = UIBezierPath(rect: rectangle)
        let shapeR = CAShapeLayer()
        shapeR.path = pathR.CGPath
        shapeR.lineWidth = 4
        shapeR.lineDashPattern = [10,30]
        shapeR.strokeColor = UIColor.redColor().CGColor
        shapeR.fillColor = UIColor.clearColor().CGColor
        view.layer.addSublayer(shapeS)
        view.layer.addSublayer(shapeR)
        view.addSubview(hamburgerView)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func addCaptureButton() {
        let buttonCenter = CGPoint(x: view.bounds.width/2 - 50, y: view.bounds.height - 120)
        let arcCenter = CGPoint(x: view.bounds.width/2, y: view.bounds.height - 70)
        let buttonFrame = CGRect(origin: buttonCenter, size: CGSize(width: 100, height: 100))
        let path = UIBezierPath(arcCenter: arcCenter, radius: CGFloat(60), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.grayColor().CGColor
        shapeLayer.lineWidth = 7.0
        view.layer.addSublayer(shapeLayer)
        captureButton = UIButton(frame: buttonFrame)
        captureButton.layer.cornerRadius = captureButton.layer.frame.width/2
        captureButton.backgroundColor = .redColor()
        view.addSubview(captureButton)
        captureButton.addTarget(self, action: #selector(ScannerViewController.touchDown), forControlEvents: UIControlEvents.TouchDown)
        captureButton.addTarget(self, action: #selector(ScannerViewController.buttonReleased), forControlEvents: UIControlEvents.TouchUpInside)
        view.bringSubviewToFront(captureButton)
    }
    
    func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: UIApplication.sharedApplication().statusBarFrame.size.height
            , width: view.frame.width, height: view.frame.height)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.position = CGPointMake(self.view.bounds.width/2, view.frame.height/2 + 20)
        previewLayer.rectForMetadataOutputRectOfInterest(CGRect(x: 10, y: view.frame.height/2 - 75, width: view.frame.width - 20, height: 150))
        view.layer.addSublayer(previewLayer)
    }
    
    func initialInstructions() {
        dimmedView.frame = view.frame
        dimmedView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.addSubview(dimmedView)
        let text = UILabel(frame: CGRect(x: 0, y: self.view.bounds.height/2 - 25 , width: view.bounds.width, height: 50))
        text.text = "Hold red button to capture the barcode"
        text.textAlignment = .Center
        text.font = UIFont(name: "System-Regular", size: 17.0)
        text.textColor = .whiteColor()
        text.alpha = 0
        dimmedView.addSubview(text)
        UIView.animateWithDuration(1, delay: 0, options: [.CurveEaseIn, .AllowUserInteraction], animations: {
            text.alpha = 1
            }, completion: nil)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 2
        animation.toValue = 1.0
        animation.duration = 0.2
        animation.beginTime = CACurrentMediaTime() + 1
        text.layer.addAnimation(animation, forKey: nil)
        UIView.animateWithDuration(3, delay: 2, options: [.AllowUserInteraction], animations: {
            text.frame.offsetInPlace(dx: 0, dy: 90)
            }, completion: nil)
        UIView.animateWithDuration(6, delay: 4, options: [.CurveEaseOut, .AllowUserInteraction], animations: {
            text.alpha = 0
            self.dimmedView.alpha = 0
            }, completion: { (_) in
                text.removeFromSuperview()
                self.dimmedView.removeFromSuperview()
        })
    }
    
    func addQuickSwitch() {
        let quickSwitch = UISwitch(frame: CGRect(x: 10, y: view.frame.height - 60, width: 100, height: 50))
        view.addSubview(quickSwitch)
    }
//------------------------------------------------------------------------------------------------------------
//      MARK: FUNCTIONS
//-------------------------------------------------------------------------------------------------------------
    
    func tap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            self.dimmedView.removeFromSuperview()
            self.view.removeGestureRecognizer(recognizer)
        }
    }
    
    func leftSlide(recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .Recognized {
            performSegueWithIdentifier("Show List", sender: self)
        }
    }
    
    func touchDown(){
        navigationController?.navigationBarHidden = true
        captureButton.alpha = 0.2
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes =
                [AVMetadataObjectTypeQRCode,
                 AVMetadataObjectTypeEAN8Code,
                 AVMetadataObjectTypeUPCECode,
                 AVMetadataObjectTypeAztecCode,
                 AVMetadataObjectTypeEAN13Code,
                 AVMetadataObjectTypeCode39Code,
                 AVMetadataObjectTypeCode128Code]
        }
    }
    
    func buttonReleased() {
        captureButton.alpha = 1
        captureSession.removeOutput(metadataOutput)
        navigationController?.navigationBarHidden = true
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue)
        }
    }
    
    func foundCode(code: String) {
        popUpInformation(code)
    }
    

//-------------------------------------------------------------------------------------------------------------
//      MARK: Handeling Alerts
//-------------------------------------------------------------------------------------------------------------
    
    func failed() { // THIS ALERT POPS UP WHEN THE DEVICE CAMERA IS NOT ENABLELED
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    func popUpInformation(barcodeText: String) {
        switch deviceModeIndex {
        case 0:
            popUpViewInformation(barcodeText)
        case 1:
            PopUpArchiveAlert(barcodeText, message: "Would you like to add this to the archiving list?")
        default:
            popUpDefrostAlert(barcodeText, message: "Would you like to add this to the defrosting list?")
        }
    }
    
    func popUpViewInformation (barcodeText: String) {
        parseBackendHandler.lookUpBarcode(barcodeText, completion: { (exists, error, returnedItem) in
            if exists {
                self.scannedItem = returnedItem
                self.performSegueWithIdentifier("ShowScanSuccessPopover", sender: self)
            } else {
                self.showText(error)
            }
        })
        self.buttonReleased()
        self.captureSession.startRunning()
    }
    
    func popUpDefrostAlert(barcodeText: String, message: String) {
        parseBackendHandler.lookUpBarcode(barcodeText) { (exists, error, returnedItem) in
            if exists {
                let ac = UIAlertController(title: barcodeText, message: message, preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { (_) in
                    self.buttonReleased()
                    self.captureSession.startRunning()
                }))
                ac.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (_) in
                    self.scannedItems.append(returnedItem)
                    self.showText("Success")
                    self.buttonReleased()
                    self.captureSession.startRunning()
                }))
                self.presentViewController(ac, animated: true, completion: nil)
            } else {
                let ac = UIAlertController(title: "Oops!", message: "This barcode has not been registered in our inventory. Please register the barcode first before defrosting it.", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (_) in
                    self.buttonReleased()
                    self.captureSession.startRunning()
                }))
                self.presentViewController(ac, animated: true, completion: nil)
            }
        }
    }
    
    func PopUpArchiveAlert(barcodeText: String, message : String) {
        parseBackendHandler.lookUpBarcode(barcodeText) { (exists, error, returnedItem) in
            if exists {
                self.showText("Item already in database")
                self.buttonReleased()
                self.captureSession.startRunning()
            } else if !exists && error == "Didn't find any object" {
                let ac = UIAlertController(title: barcodeText, message: message, preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "No", style: .Default, handler: { (_) in
                    self.captureSession.startRunning()
                }))
                ac.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (_) in
                    self.captureSession.startRunning()
                    let plateName = ac.textFields![0]
                    let libraryName = ac.textFields![1]
                    let projectName = ac.textFields![2]
                    let additionalInfo = ac.textFields![3]
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let strDate = dateFormatter.stringFromDate(NSDate())
                    
                    self.scannedItem = ScannedItem()
                    self.scannedItem.plateName = plateName.text!
                    self.scannedItem.library = libraryName.text!
                    self.scannedItem.project = projectName.text!
                    self.scannedItem.detailedInformation = additionalInfo.text!
                    self.scannedItem.dateCreated = strDate
                    self.scannedItem.barcode = barcodeText
                    self.scannedItem.creatorFirstName = self.curentUser.firstName
                    self.scannedItem.creatorLastName = self.curentUser.lastName
                    self.scannedItem.creatorUsername = self.curentUser.username
                    self.scannedItems.append(self.scannedItem)
                }))
                self.buttonReleased()
                ac.actions.last?.enabled = false
                ac.addTextFieldWithConfigurationHandler { (textField) in
                    textField.borderStyle = .RoundedRect
                    textField.clearButtonMode = .Always
                    textField.returnKeyType = .Next
                    textField.placeholder = "Plate Name (>4 characters)"
                    textField.keyboardAppearance = .Dark
                    textField.addTarget(self, action: #selector(self.alertTextFieldDidChange), forControlEvents: .EditingChanged)
                }
                ac.addTextFieldWithConfigurationHandler { (textField) in
                    textField.borderStyle = .RoundedRect
                    textField.clearButtonMode = .Always
                    textField.returnKeyType = .Next
                    textField.placeholder = "Library Name (Optional)"
                    textField.keyboardAppearance = .Dark
                }
                ac.addTextFieldWithConfigurationHandler { (textField) in
                    textField.borderStyle = .RoundedRect
                    textField.clearButtonMode = .Always
                    textField.returnKeyType = .Next
                    textField.placeholder = "Project (>2 characters)"
                    textField.keyboardAppearance = .Dark
                    textField.addTarget(self, action: #selector(self.alertTextFieldDidChange), forControlEvents: .EditingChanged)
                }
                ac.addTextFieldWithConfigurationHandler { (textField) in
                    textField.borderStyle = .RoundedRect
                    textField.clearButtonMode = .Always
                    textField.placeholder = "Additional info"
                    textField.keyboardAppearance = .Dark
                }
                self.presentViewController(ac, animated: true, completion: nil)
                for textField: UIView in ac.textFields! {
                    let container : UIView = textField.superview!
                    let effectView : UIView = container.superview!.subviews[0]
                    container.backgroundColor = UIColor.clearColor()
                    effectView.removeFromSuperview()
                }
            }
        }
    }
    
    func alertTextFieldDidChange()  {
        let alertController = (self.presentedViewController as! UIAlertController)
        let plateName = alertController.textFields![0]
        let projectName = alertController.textFields![2]
        let yes = alertController.actions.last
        yes!.enabled = (plateName.text?.characters.count > 4 && projectName.text?.characters.count > 2)
        
    }
    
    func showText(text : String) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .Center
        label.font = UIFont(name: "System-Regular", size: 17.0)
        label.textColor = .whiteColor()
        label.alpha = 0
        label.sizeToFit()
        label.center = self.view.center
        view.addSubview(label)
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: {
            label.alpha = 1
            }, completion: nil)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.5
        animation.toValue = 1.0
        animation.duration = 0.3
        animation.beginTime = CACurrentMediaTime() + 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        UIView.animateWithDuration(1.5, delay: 0.5, options: .CurveEaseOut, animations: {
            label.alpha = 0
            }, completion: { (_) in
                label.removeFromSuperview()
        })
        label.layer.addAnimation(animation, forKey: nil)
    }
    
//-------------------------------------------------------------------------------------------------------------
//      MARK: Handeling Segue
//-------------------------------------------------------------------------------------------------------------

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Settings" {
            if let destinationVC = segue.destinationViewController as? SettingsTableViewController {
                destinationVC.index = self.deviceModeIndex
            }
        } else if segue.identifier == "Show List" {
            if let destinationVC = segue.destinationViewController as? ListTableViewController {
                destinationVC.scannedItems = self.scannedItems
                destinationVC.deviceModeIndex = self.deviceModeIndex
                destinationVC.curentUser = self.curentUser
            }
        } else if segue.identifier == "ShowScanSuccessPopover" {
            if let destinationVC = segue.destinationViewController as? ScanSuccessPopOverVC {
                destinationVC.scannedItem = self.scannedItem
            }
        }
    }
}