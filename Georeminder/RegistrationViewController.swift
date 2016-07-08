//
//  RegistrationViewController.swift
//  Georeminder
//
//  Created by Admin on 0807..16.
//  Copyright © 2016 SuperCoders. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var userNametextfield: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var IAHAAButton: UIButton!
    
    let backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func RegisterButtoTapped(sender: AnyObject) {
        let userName = userNametextfield.text!
        let userEmail = userEmailTextField.text!
        let userPass = userPasswordTextField.text!
        let passConfirm = confirmPasswordTextField.text!
        
        //check input
        
        if(userName.isEmpty || userEmail.isEmpty || userPass.isEmpty || passConfirm.isEmpty ){
            displayAlertMessage("All fields are required")
            
            return
        }
        
        if(!validateEmail(userEmail)){
            displayAlertMessage("Email is in incorrect format")
            return
        }
        
        //check pass and pass confirm are same
        
        if(userPass != passConfirm){
            displayAlertMessage("Passwords do not match")
            return
        }
        
        //register
        toggleUI(false) // disable user interaction
        
        let user = BackendlessUser()
        user.name = userName
        user.email = userEmail
        user.password = userPass
        
        backendless.userService.registering(user,
            response: { (registeredUser : BackendlessUser!) -> () in
                print("User has been registered (ASYNC): \(registeredUser)")
                
                self.toggleUI(true) // enable user interaction
                
                // Display alert message with confirmation.
                let myAlert = UIAlertController(title:"Alert", message:"Registration is successful. Thank you!", preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default){ action in
                    self.dismissViewControllerAnimated(true, completion:nil);
                }
                
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated:true, completion:nil);
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
                if(fault.faultCode == "3033"){
                     self.displayAlertMessage("User with such email already exists");
                }else{
                     self.displayAlertMessage("\(fault)");
                }
               
                self.toggleUI(true) // enable user interaction
            }
        )
        
        
        
    }

    @IBAction func IHaveAlreadyHaveAnAccountButtonTapped(sender: AnyObject) {
        // close registration view
        self.dismissViewControllerAnimated(true, completion:nil);
    }
    
    func displayAlertMessage(message: String){
        
        let myAlert = UIAlertController(title:"Alert", message:message, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated:true, completion:nil);
        
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
        
    }
    
    func toggleUI(enabled:Bool){
        userNametextfield.userInteractionEnabled = enabled
        userEmailTextField.userInteractionEnabled = enabled
        userPasswordTextField.userInteractionEnabled = enabled
        confirmPasswordTextField.userInteractionEnabled = enabled
        registerButton.userInteractionEnabled = enabled
        IAHAAButton.userInteractionEnabled = enabled


    }
}
