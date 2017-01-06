//
//  ViewController.swift
//  TesterApp
//
//  Created by Jack Rentz on 1/2/17.
//  Copyright © 2017 Boxer Property. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var labelOutlet: UILabel!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        loginButtonOutlet.titleLabel?.text = "Loading"
        loginButtonOutlet.isEnabled = false
        activityIndicator.startAnimating()
        if usernameField.text == "username" {
            if passwordField.text == "password" {
                loginButtonOutlet.isEnabled = true
                activityIndicator.stopAnimating()
                passwordField.text = ""
                usernameField.text = ""
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "SuccessNavigationController")
                self.present(vc, animated: true, completion: nil)
            } else {
                loginButtonOutlet.isEnabled = true
                activityIndicator.stopAnimating()
                passwordField.text = ""
                showAlertWithTitle(title: "Incorrect username or password", message: "please re-enter credentials")
            }
        } else {
            loginButtonOutlet.isEnabled = true
            activityIndicator.stopAnimating()
            passwordField.text = ""
            showAlertWithTitle(title: "Incorrect username or password", message: "please re-enter credentials")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        
        activityIndicator.hidesWhenStopped = true
        authenticateUser()
    }
    
    func authenticateUser() {
        
        let context = LAContext()
        var error: NSError?
        
        // Check if the device is compatible with TouchID and can evaluate the policy.
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let myLocalizedReasonString = "Use fingerprint to log in"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "SuccessNavigationController")
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        print("TouchID cancelled")
                    }
                }
                
            }
            
        } else {
            print("\(error!.localizedDescription)")
            showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)")
            return
        }
        
    }
    
    func showAlertWithTitle(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(OKAction)
        
        DispatchQueue.main.async {
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func showPasswordAlert() {
        let alertController = UIAlertController(title: "Touch ID Cancelled", message: "Must enter password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            print("going to enter password")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
