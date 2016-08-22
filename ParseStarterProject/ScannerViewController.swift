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
//    var discoveredBorder = DiscoveredBarCodeView()
//    var timer: NSTimer?
    let metadataOutput = AVCaptureMetadataOutput()
    let parseHandler = ParseBackendHandler()
//    @IBOutlet weak var captureButton: UIButton!
    var captureButton = UIButton()
    var deviceModeIndex = 0
    let modesArray : [String] = ["View mode", "Archive mode", "Defrost mode"]
    var scannedItem : ScannedItem!
    var scannedItems = [ScannedItem]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.hidesBarsOnTap = true
        navigationItem.title = modesArray[deviceModeIndex]
        createFakeScanneditem()
    }
    
    func createFakeScanneditem() {
        scannedItem = ScannedItem()
        scannedItem.barcode = "15627326382"
        scannedItem.creatorFirstName = "Sam"
        scannedItem.creatorLastName = "Kheirandish"
        scannedItem.creatorUsername = "Namak"
        scannedItem.dateCreated = "Aug-2016"
        scannedItem.dateLastDefrosted = "12-Aug-2016"
        scannedItem.detailedInformation = "Selection of positive clones from mixec CMU-assay for both 1hr and 18hr and when it was replicated there were some cross contamination due to condensations on the lid which dropped down on to the plate"
        scannedItem.lastDefrostedBy = "Keith Miewis"
        scannedItem.library = "CO182"
        scannedItem.plateName = "CO182-01"
        scannedItem.project = "Hydrocarbon"
        scannedItem.numberOfThaws = 3
        scannedItems.append(scannedItem!)
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
        let leftPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ScannerViewController.leftSlide))
        leftPan.edges = .Left
        self.view.addGestureRecognizer(leftPan)
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
    func leftSlide(recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .Recognized {
            performSegueWithIdentifier("Show List", sender: self)
        }
    }
    func touchDown(){
        print("button pressed")
        navigationController?.navigationBarHidden = true
        captureButton.alpha = 0.2
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        }

    }
    func buttonReleased() {
        print("button released")
        captureButton.alpha = 1
        captureSession.removeOutput(metadataOutput)
        navigationController?.navigationBarHidden = true
    }
    
    func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: UIApplication.sharedApplication().statusBarFrame.size.height
            , width: view.frame.width, height: view.frame.height)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.position = CGPointMake(self.view.bounds.width/2, view.frame.height/2 + 20)
        view.layer.addSublayer(previewLayer)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
//    func startTimer() {
//        if timer?.valid != true {
//            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(ScannerViewController.removeBorder), userInfo: nil, repeats: false)
//        } else {
//            timer?.invalidate()
//        }
//    }
    
//    func removeBorder() {
//        self.discoveredBorder.hidden = true
//    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
       
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue)
//            discoveredBorder.frame = readableObject.bounds
//            discoveredBorder.hidden = false
//            print(readableObject.corners)
//            let identifiedCorners = self.translatePoints(readableObject.corners, fromView: view, toView: discoveredBorder)
//            discoveredBorder.drawBorder(identifiedCorners)
//            startTimer()
        }
    }
    
//    func translatePoints(points: [AnyObject], fromView: UIView, toView: UIView) -> [CGPoint] {
//        print("got to translated points")
//        var translatedPoints : [CGPoint] = []
//        for point in points {
//            let dict = point as! NSDictionary
//            let x = CGFloat((dict.objectForKey("X") as! NSNumber).floatValue)
//            let y = CGFloat((dict.objectForKey("Y") as! NSNumber).floatValue)
//            let curr = CGPointMake(x, y)
//            let currFinal = fromView.convertPoint(curr, toView: toView)
//            translatedPoints.append(currFinal)//These are the corners which were detected by the framework and we will use it to display the identified barcode.
//        }
//        return translatedPoints//The translatedPoints in the above function can be used to draw a bezierpath.
//    }


    func foundCode(code: String) {
        popUpInformation(code)
        parseHandler.searchBackendDataAnalysis(code)
    }
    
    func popUpInformation(barcodeText: String) {
        let ac = UIAlertController(title: "\(barcodeText)", message: "Would you like to add this to the list?", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (UIAlertAction) in
            self.captureSession.startRunning()
            self.parseHandler.addBarcodeToDataBase(barcodeText)
            
        }))
        ac.addAction(UIAlertAction(title: "No", style: .Default, handler: { (_) in
            self.captureSession.startRunning()
        }))
        buttonReleased()
        presentViewController(ac, animated: true, completion: nil)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        view.bringSubviewToFront(captureButton)
        if fromInterfaceOrientation == .Portrait {
            previewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height)
            previewLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds)/2, CGRectGetMidY(self.view.bounds))
            previewLayer.captureDevicePointOfInterestForPoint(previewLayer.position)
        } else {
            previewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3)
            previewLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), view.frame.height/6)
            previewLayer.captureDevicePointOfInterestForPoint(previewLayer.position)
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        switch toInterfaceOrientation {
        case .LandscapeLeft:
            previewLayer.connection.videoOrientation = .LandscapeLeft
        case .LandscapeRight:
            previewLayer.connection.videoOrientation = .LandscapeRight
        case .PortraitUpsideDown:
            previewLayer.connection.videoOrientation = .PortraitUpsideDown
        default:
            previewLayer.connection.videoOrientation = .Portrait
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Settings" {
            if let destinationVC = segue.destinationViewController as? SettingsTableViewController {
                destinationVC.index = self.deviceModeIndex
            }
        } else if segue.identifier == "Show List" {
            if let destinationVC = segue.destinationViewController as? ListTableViewController {
                destinationVC.scannedItems = self.scannedItems
            }
        }
    }
}
