//
//  LoginPage.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-05.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class LoginPage: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var loginButton: LoginButton!
    @IBOutlet weak var informationHeight: NSLayoutConstraint!
    @IBOutlet weak var loginButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logo: AnimatedMaskLabel!
    var signUpState = false
    
    @IBAction func login(sender: AnyObject) {
        if !signUpState && usernameTextField.text != "" && passwordTextField.text != "" {
            PFUser.logInWithUsernameInBackground(usernameTextField.text!, password:passwordTextField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // self.performSegueWithIdentifier("riderView", sender: self)
                } else {
                    let errorString = error!.userInfo["error"] as? String
                    self.showLoginAlert("Login Failed", message:errorString!)
                }
            }
        } else if signUpState && usernameTextField.text != "" && passwordTextField.text != "" && retypePasswordTextField.text != "" && firstNameTextField.text != "" && lastNameTextField.text != "" {
            passwordTextField.secureTextEntry = false
            retypePasswordTextField.secureTextEntry = false
            self.showSignupAlert("Great!", message: "Is this information correct?")
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
        usernameTextField.layer.addAnimation(growAnimation, forKey: nil)
        growAnimation.beginTime = CACurrentMediaTime() + animationDuration/3
        passwordTextField.layer.addAnimation(growAnimation, forKey: nil)
        loginButton.layer.addAnimation(growAnimation, forKey: nil)
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = animationDuration
        fadeInAnimation.fillMode = kCAFillModeBackwards
        usernameTextField.layer.addAnimation(fadeInAnimation, forKey: nil)
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
            self.retypePasswordTextField.alpha = 0
            self.firstNameTextField.alpha = 0
            self.lastNameTextField.alpha = 0
            self.passwordTextField.returnKeyType = .Next
            UIView.animateWithDuration(0.5, animations: {
                self.informationHeight.constant = 40
                self.loginButton.backgroundColor = self.loginButton.signupColor
                self.loginButton.setTitle("Sign up", forState: .Normal)
                self.clearTextFields()
                self.retypePasswordTextField.hidden = false
                self.firstNameTextField.hidden = false
                self.lastNameTextField.hidden = false
                UIView.animateWithDuration(0.5, animations: { 
                    self.retypePasswordTextField.alpha = 1
                    self.firstNameTextField.alpha = 1
                    self.lastNameTextField.alpha = 1
                })
                self.loginButtonHeightConstraint.constant = 129
                self.usernameTextField.becomeFirstResponder()
                self.view.layoutIfNeeded()
            })
        }
        alert.addAction(signUpAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSignupAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (action) in
            self.signUpState = false
            UIView.animateWithDuration(0.5, animations: {
                self.clearTextFields()
                self.loginButton.backgroundColor = self.loginButton.loginColor
                self.loginButton.setTitle("Login", forState: .Normal)
                self.passwordTextField.secureTextEntry = true
                self.retypePasswordTextField.secureTextEntry = true
                self.retypePasswordTextField.alpha = 0
                self.firstNameTextField.alpha = 0
                self.lastNameTextField.alpha = 0
                self.loginButtonHeightConstraint.constant = 29
                self.informationHeight.constant = self.view.layer.bounds.height/3
                self.view.layoutIfNeeded()
                }, completion: { (_) in
                    self.retypePasswordTextField.hidden = true
                    self.firstNameTextField.hidden = true
                    self.lastNameTextField.hidden = true
                    self.usernameTextField.becomeFirstResponder()
            })
        }
        let signUpAction = UIAlertAction(title: "Sign up", style: .Default) { (action) in
            if self.passwordTextField.text == self.retypePasswordTextField.text {
                let newUser = PFUser()
                newUser.username = self.usernameTextField.text
                newUser.password = self.passwordTextField.text
                newUser["firstName"] = self.firstNameTextField.text
                newUser["lastName"] = self.lastNameTextField.text
                newUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    if(error != nil) {
                        let errorString = error!.userInfo["error"] as? String
                        self.showAlert("Problem Signing Up", message:errorString!)
                    } else {
                        self.showAlert("Success!", message:"You have signed up successfully.")
                        // self.performSegueWithIdentifier("riderView", sender: self)
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
    func loginState() {
        passwordTextField.returnKeyType = .Join
        loginButton.backgroundColor = self.loginButton.loginColor
        loginButton.setTitle("Login", forState: .Normal)
        passwordTextField.secureTextEntry = true
        retypePasswordTextField.secureTextEntry = true
        UIView.animateWithDuration(0.5) { 
            self.fadeOutFields()
        }
        loginButtonHeightConstraint.constant = 29
        informationHeight.constant = self.view.layer.bounds.height/3
        hidetextFields()
        usernameTextField.becomeFirstResponder()
    }
    func signupState() {
        passwordTextField.returnKeyType = .Next
        fadeOutFields()
        loginButton.backgroundColor = self.loginButton.signupColor
        loginButton.setTitle("Sign up", forState: .Normal)
        showTextFields()
        UIView.animateWithDuration(0.5) { 
            self.fadeInFields()
        }
        loginButtonHeightConstraint.constant = 129
    }
    func hidetextFields() {
        retypePasswordTextField.hidden = true
        firstNameTextField.hidden = true
        lastNameTextField.hidden = true
    }
    func fadeOutFields() {
        retypePasswordTextField.alpha = 0
        firstNameTextField.alpha = 0
        lastNameTextField.alpha = 0
    }
    func showTextFields() {
        retypePasswordTextField.hidden = false
        firstNameTextField.hidden = false
        lastNameTextField.hidden = false
    }
    func fadeInFields() {
        retypePasswordTextField.alpha = 1
        firstNameTextField.alpha = 1
        lastNameTextField.alpha = 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    func clearTextFields() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        retypePasswordTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
    }

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
            if UIDevice.currentDevice().orientation == .Portrait {
                self.informationHeight.constant = self.signUpState ? 40 : self.view.layer.bounds.height/6
            } else {
                self.informationHeight.constant = 40
            }
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
            self.informationHeight.constant = self.signUpState ? self.view.layer.bounds.height/6 : self.view.layer.bounds.height/3
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
