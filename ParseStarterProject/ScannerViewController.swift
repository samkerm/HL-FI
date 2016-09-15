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
    let modesArray : [String] = ["View mode", "Archive mode", "Defrost mode", "Discharge mode"]
    var scannedItem : ScannedItem!
    var scannedItems = [ScannedItem]()
    var curentUser = CurentUser()
    let dimmedView = UIView()
    var scannedBarcode = ""
    
    
//-------------------------------------------------------------------------------------------------------------
//      MARK: APEARANCE
//-------------------------------------------------------------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
        navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.barHideOnSwipeGestureRecognizer.enabled = false
        navigationItem.title = modesArray[deviceModeIndex]
        switch deviceModeIndex {
        case 1,2:
            navigationItem.leftBarButtonItem?.enabled = true
        default:
            navigationItem.leftBarButtonItem?.enabled = false
        }
    }
    override func viewDidDisappear(animated: Bool) {
        hideHamburgerMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        addCaptureSession()
        addPreviewLayer()
        addCaptureButton()
        drawTargetRectangle()
        initialInstructions()
        addGuestures()
    }
    
    func drawTargetRectangle() {
        let square = CGRect(x: view.frame.width/2 - 75, y: view.frame.height/2 - 75, width: 150, height: 150)
        let rectangle = CGRect(x: 10, y: view.frame.height/2 - 40, width: view.frame.width - 20, height: 80)
        let pathS = UIBezierPath(rect: square)
        let shapeS = CAShapeLayer()
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
    }
    func addHamburgerMenu() {
        let hamburger = UIImage(named: "menu")
        let hamburgerView = UIImageView(image: hamburger)
        hamburgerView.tag = 1001
        hamburgerView.frame = CGRect(x: self.view.bounds.width - hamburgerView.frame.width - 15, y: 0, width: hamburgerView.frame.width, height: hamburgerView.frame.height)
        view.addSubview(hamburgerView)
        let animationDuration = 0.4
        let fillmode = kCAFillModeBackwards
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = -6.0
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotateAnimation, fadeAnimation]
        groupAnimation.duration = animationDuration
        groupAnimation.fillMode = fillmode
        hamburgerView.layer.addAnimation(groupAnimation, forKey: "menuRollUP")
        UIView.animateWithDuration(animationDuration, animations: {
            hamburgerView.frame.origin.y += 40
            }, completion: nil)
    }
    func hideHamburgerMenu() {
        for subview in self.view.subviews {
            if subview.tag == 1001 {
                let animationDuration = 0.4
                let fillmode = kCAFillModeBackwards
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = 0.0
                rotateAnimation.toValue = 6.0
                let fadeAnimation = CABasicAnimation(keyPath: "opacity")
                fadeAnimation.fromValue = 1
                fadeAnimation.toValue = 0
                let groupAnimation = CAAnimationGroup()
                groupAnimation.animations = [rotateAnimation, fadeAnimation]
                groupAnimation.duration = animationDuration
                groupAnimation.fillMode = fillmode
                subview.layer.addAnimation(groupAnimation, forKey: "menuRollUP")
                UIView.animateWithDuration(animationDuration, animations: {
                    subview.frame.origin.y += -40
                    }, completion: { (_) in
                        subview.removeFromSuperview()
                })
            }
        }
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
                if self.view.gestureRecognizers?.count == 3 {
                    self.view.gestureRecognizers?.removeLast()
                }
        })
    }

//------------------------------------------------------------------------------------------------------------
//      MARK: FUNCTIONS
//-------------------------------------------------------------------------------------------------------------
    
    func addCaptureSession() {
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
        scannedBarcode = code
    }
    func addGuestures() {
        let leftPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.leftSlide(_:)))
        leftPan.edges = .Left
        self.view.addGestureRecognizer(leftPan)
        let rightPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(rightSlide(_:)))
        rightPan.edges = .Right
        self.view.addGestureRecognizer(rightPan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    func tap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            hideHamburgerMenu()
            self.dimmedView.removeFromSuperview()
            self.view.removeGestureRecognizer(recognizer)
        }
    }
    
    func leftSlide(recognizer: UIScreenEdgePanGestureRecognizer) {
        if deviceModeIndex != 0 && deviceModeIndex != 3 && recognizer.state == .Began {
            performSegueWithIdentifier("Show List", sender: self)
        }
    }
    func rightSlide(recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .Recognized {
            performSegueWithIdentifier("Show Settings", sender: self)
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard touches.count > 1 else {
            if navigationController?.navigationBar.hidden == true {
                hideHamburgerMenu()
            } else {
                addHamburgerMenu()
            }
            return
        }
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
        case 2:
            popUpDefrostAlert(barcodeText, message: "Would you like to add this to the defrosting list?")
        default:
            popUpDischargeAlert(barcodeText, message: "Would you like to remove this item from database?")
        }
    }
    
    func popUpViewInformation (barcodeText: String) {
        parseBackendHandler.lookUpBarcode(barcodeText, completion: { (exists, error, returnedItem) in
            if exists {
                self.scannedItem = returnedItem
                switch self.scannedItem.type {
                case "Plate":
                    self.performSegueWithIdentifier("ShowPlateScanSuccessPopover", sender: self)
                default:
                    self.performSegueWithIdentifier("ShowProductScanSuccessPopover", sender: self)
                }
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
            } else if !exists {
                self.performSegueWithIdentifier("ShowArchivePopover", sender: self)
                self.buttonReleased()
                self.captureSession.startRunning()
            }
        }
    }
    
    func popUpDischargeAlert(barcode : String, message : String) {
        let ac = UIAlertController(title: "Discharge?", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "No", style: .Default, handler: { (_) in
            self.buttonReleased()
            self.captureSession.startRunning()
        }))
        ac.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (_) in
            self.parseBackendHandler.removeFromDatabase(barcode, completion: { (success, found, deleted) in
                if success {
                    self.showText("SUCCESS!\nFound: \(found)\nDeleted: \(deleted)")
                } else {
                    self.showText("Failed!\nFound: \(found)\nDeleted: \(deleted)")
                }
            })
            self.buttonReleased()
            self.captureSession.startRunning()
        }))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    func showText(text : String) {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
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
        UIView.animateWithDuration(3, delay: 0.5, options: .CurveEaseOut, animations: {
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
        } else if segue.identifier == "ShowPlateScanSuccessPopover" {
            if let destinationVC = segue.destinationViewController as? PlateScanSuccessPopOverVC {
                destinationVC.scannedItem = self.scannedItem
            }
        } else if segue.identifier == "ShowProductScanSuccessPopover" {
            if let destinationVC = segue.destinationViewController as? ProductScanSuccessViewController {
                destinationVC.scannedItem = self.scannedItem
            }
        }else if segue.identifier == "ShowArchivePopover" {
            if let destinationVC = segue.destinationViewController as? ArchivePopOverViewController {
                destinationVC.curentUser = self.curentUser
                destinationVC.scannedBarcode = self.scannedBarcode
                destinationVC.delegate = self
            }
        }
    }
}

extension ScannerViewController : ArchivePopOverViewControllerDelegate {
    func archiveItemReturned(value: ScannedItem) {
        self.scannedItem = value
        self.scannedItems.append(self.scannedItem)
    }
}

