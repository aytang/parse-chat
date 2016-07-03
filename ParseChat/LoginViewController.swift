//
//  ViewController.swift
//  ParseChat
//
//  Created by Nicholas Aiwazian on 2/3/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onSignupTapped(sender: UIButton) {
        let newUser = PFUser()
        newUser.username = self.emailTextField.text!
        newUser.password = self.passwordTextField.text!
        newUser.email = self.emailTextField.text!
        newUser.signUpInBackgroundWithBlock { (succeeded: Bool, error:NSError?) -> Void in
            if let error = error {
                self.showAlertViewWithTitle("Error", andMessage: error.description)
            } else {
                self.handleSuccessfulLoginOrSignup()
            }
        }
    }
    
    @IBAction func onLoginTapped(sender: UIButton) {
        let userName = self.emailTextField.text!
        let password = self.passwordTextField.text!
        PFUser.logInWithUsernameInBackground(userName, password: password) { (user: PFUser?, error:NSError?) -> Void in
            if let _ = user {
                self.handleSuccessfulLoginOrSignup()
            }
            else {
                self.showAlertViewWithTitle("Error", andMessage: "Could not log in")
            }
        }
    }
    
    func handleSuccessfulLoginOrSignup() {
        self.performSegueWithIdentifier("chatSegue", sender: self)
    }
    
    func showAlertViewWithTitle(title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: title, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

