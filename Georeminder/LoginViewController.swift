//
//  LoginViewController.swift
//  Georeminder
//
//  Created by Admin on 0807..16.
//  Copyright © 2016 SuperCoders. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let backendless = Backendless.sharedInstance()

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text!
        let userPassword = userPasswordTextField.text!
        
        //check input if emty
        
        if(userEmail.isEmpty || userPassword.isEmpty){
            displayAlertMessage("All fields are required to login")
            return
        }
        
        // check email format
        if(!userEmail.validateEmail()){
            
            displayAlertMessage("Check your email format")
            return
        }
        
        // login async
        toggleUI(false)
        
        backendless.userService.login(
            userEmail, password:userPassword,
            response: { ( user : BackendlessUser!) -> () in
                print("User has been logged in (ASYNC): \(user)")
                
                self.backendless.userService.setStayLoggedIn(true) // stay looged in even after app restarts
                
                self.toggleUI(true)
                
                //close login, sucess
                self.dismissViewControllerAnimated(true, completion:nil);
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
                
                self.toggleUI(true)
                
                
                if(fault.faultCode == "3003"){
                    self.displayAlertMessage("Invalid login or password");
                }else{
                    self.displayAlertMessage("\(fault)");
                }
                
            }
        )
        
        
        
    }
    
    func displayAlertMessage(message: String){
        
        let myAlert = UIAlertController(title:"Alert", message:message, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated:true, completion:nil);
        
    }
    
    func toggleUI(enabled:Bool){
        userEmailTextField.userInteractionEnabled = enabled
        userPasswordTextField.userInteractionEnabled = enabled
        loginButton.userInteractionEnabled = enabled
        registerButton.userInteractionEnabled = enabled
        
        
    }


}
