//
//  LoginPage.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-05.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class LoginPage: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: LoginButton!
    @IBOutlet weak var informationHeight: NSLayoutConstraint!
    @IBOutlet weak var loginButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logo: AnimatedMaskLabel!
    var signUpState = false
    let parseBackendHandler = ParseBackendHandler()
    var creator = CurentUser()
    
    @IBAction func login(sender: AnyObject) {
        if !signUpState && !usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            parseBackendHandler.loginWithUsernameAndPassword(usernameTextField.text!, password: passwordTextField.text!, complition: { (success, error, creator) in
                if success {
                    self.creator = creator
                    self.performSegueWithIdentifier("ScanView", sender: self)
                } else {
                    self.showLoginAlert("Login Failed", message: error)
                }
            })
        } else if signUpState && !usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !retypePasswordTextField.text!.isEmpty && !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty {
            if isValidEmail(emailTextField.text!) {
                passwordTextField.secureTextEntry = false
                retypePasswordTextField.secureTextEntry = false
                self.showSignupAlert("Great!", message: "Is this information correct?")
            } else {
                self.showAlert("E-mail not valid", message: "Make sure you use a Canadian email domain.")
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        if parseBackendHandler.checkCurentUserStatus({ (curentUser) in
            self.creator = curentUser
        }) {
            performSegueWithIdentifier("ScanView", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSnowFlakes()
        let animationDuration = 0.5
        let growAnimation = CABasicAnimation(keyPath: "transform.scale")
        growAnimation.fromValue = 0
        growAnimation.toValue = 1
        growAnimation.duration = animationDuration
        growAnimation.fillMode = kCAFillModeBackwards
        growAnimation.beginTime = CACurrentMediaTime() + animationDuration/2
        usernameTextField.layer.addAnimation(growAnimation, forKey: nil)
        growAnimation.beginTime = CACurrentMediaTime() + animationDuration
        passwordTextField.layer.addAnimation(growAnimation, forKey: nil)
        loginButton.layer.addAnimation(growAnimation, forKey: nil)
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = animationDuration
        fadeInAnimation.fillMode = kCAFillModeBackwards
        fadeInAnimation.beginTime = CACurrentMediaTime() + animationDuration/2
        usernameTextField.layer.addAnimation(fadeInAnimation, forKey: nil)
        fadeInAnimation.beginTime = CACurrentMediaTime() + animationDuration
        passwordTextField.layer.addAnimation(fadeInAnimation, forKey: nil)
        loginButton.layer.addAnimation(fadeInAnimation, forKey: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        view.bringSubviewToFront(usernameTextField)
        view.bringSubviewToFront(passwordTextField)
        view.bringSubviewToFront(loginButton)
        loginButton.layer.cornerRadius = 12.5
        loginButton.backgroundColor = loginButton.loginColor
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        retypePasswordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        informationHeight.constant = view.layer.bounds.height/3
    }
    func showAlert(title:String, message:String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
    }
    
    func showLoginAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: "\(message)\n Would you like to sign up?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let signUpAction = UIAlertAction(title: "Sign up", style: .Default) { (action) in
            self.signUpState = true
            self.signupState()
            self.usernameTextField.becomeFirstResponder()
            self.view.layoutIfNeeded()
        }
        alert.addAction(signUpAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSignupAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (action) in
            self.signUpState = false
            self.loginState()
            self.view.layoutIfNeeded()
        }
        let signUpAction = UIAlertAction(title: "Sign up", style: .Default) { (action) in
            if self.passwordTextField.text == self.retypePasswordTextField.text {
                self.parseBackendHandler.parseSignUpInBackgroundWithBlock(self.usernameTextField.text!, password: self.passwordTextField.text!, firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, email: self.emailTextField.text!, completion: { (success, error, creator) in
                    if success {
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            self.showAlert("Success!", message:"You have signed up successfully.")
//                        })
                        self.creator = creator
                        self.performSegueWithIdentifier("ScanView", sender: self)
                    } else {
                        self.showAlert("Problem Signing Up", message: error)
                    }
                })
            } else {
                self.showAlert("Passwords don't match", message: "Please make sure the \"Password\" textfield matches the \"Re-type Password\" textfield.")
                self.passwordTextField.text = ""
                self.retypePasswordTextField.text = ""
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(signUpAction)
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func addSnowFlakes() {
        let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width, height: 50.0)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        emitter.emitterShape = kCAEmitterLayerRectangle
        emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
        emitter.emitterSize = rect.size
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "flake.png")!.CGImage
        emitterCell.birthRate = 150
        emitterCell.lifetime = 3.5
        emitter.emitterCells = [emitterCell]
        emitterCell.yAcceleration = 70.0
        emitterCell.xAcceleration = 10.0
        emitterCell.velocity = 20.0
        emitterCell.emissionLongitude = CGFloat(-M_PI)
        emitterCell.velocityRange = 200.0
        emitterCell.emissionRange = CGFloat(M_PI_2)
        emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).CGColor
        emitterCell.redRange   = 0.1
        emitterCell.greenRange = 0.1
        emitterCell.blueRange  = 0.1
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.8
        emitterCell.scaleSpeed = -0.15
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        emitterCell.lifetimeRange = 1.0
        view.layer.addSublayer(emitter)
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.ca"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    func loginState() {
        clearTextFields()
        passwordTextField.returnKeyType = .Join
        loginButton.backgroundColor = self.loginButton.loginColor
        loginButton.setTitle("Login", forState: .Normal)
        passwordTextField.secureTextEntry = true
        retypePasswordTextField.secureTextEntry = true
        UIView.animateWithDuration(0.5) { 
            self.fadeOutFields()
        }
        loginButtonHeightConstraint.constant = 30
        informationHeight.constant = self.view.layer.bounds.height/3
        hidetextFields()
        usernameTextField.becomeFirstResponder()
    }
    func signupState() {
        passwordTextField.returnKeyType = .Next
        fadeOutFields()
        clearTextFields()
        loginButton.backgroundColor = self.loginButton.signupColor
        loginButton.setTitle("Sign up", forState: .Normal)
        showTextFields()
        UIView.animateWithDuration(0.5) { 
            self.fadeInFields()
        }
        loginButtonHeightConstraint.constant = 160
    }
    func clearTextFields() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        retypePasswordTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
    }
    func hidetextFields() {
        retypePasswordTextField.hidden = true
        firstNameTextField.hidden = true
        lastNameTextField.hidden = true
        emailTextField.hidden = true
    }
    func fadeOutFields() {
        retypePasswordTextField.alpha = 0
        firstNameTextField.alpha = 0
        lastNameTextField.alpha = 0
        emailTextField.alpha = 0
    }
    func showTextFields() {
        retypePasswordTextField.hidden = false
        firstNameTextField.hidden = false
        lastNameTextField.hidden = false
        emailTextField.hidden = false
    }
    func fadeInFields() {
        retypePasswordTextField.alpha = 1
        firstNameTextField.alpha = 1
        lastNameTextField.alpha = 1
        emailTextField.alpha = 1
    }

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationNavigationController = segue.destinationViewController as! UINavigationController
        let targetController = destinationNavigationController.topViewController as! ScannerViewController
        targetController.creator = self.creator
    }
/*
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        view.endEditing(true)
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
            if self.signUpState {
                if UIDevice.currentDevice().orientation == .Portrait {
                    self.informationHeight.constant = self.view.layer.bounds.height/6
                } else {
                    self.informationHeight.constant = 40
                }
            } else {
                self.informationHeight.constant = self.view.layer.bounds.height/3
            }
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
 */
}
extension LoginPage: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if signUpState {
            switch textField {
            case usernameTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                retypePasswordTextField.becomeFirstResponder()
            case retypePasswordTextField:
                firstNameTextField.becomeFirstResponder()
            case firstNameTextField:
                lastNameTextField.becomeFirstResponder()
            case lastNameTextField:
                emailTextField.becomeFirstResponder()
            default:
                login(self)
            }
        } else {
            if textField == usernameTextField {
                passwordTextField.becomeFirstResponder()
            } else if textField == passwordTextField {
                login(self)
            }
        }
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
            self.logo.alpha = self.signUpState ? 0 : 1
            self.informationHeight.constant = self.signUpState ? 10 : self.view.layer.bounds.height/6
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
            self.logo.alpha = 1
            self.informationHeight.constant = self.signUpState ? self.view.layer.bounds.height/6 : self.view.layer.bounds.height/3
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
