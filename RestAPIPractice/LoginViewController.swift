//
//  LoginViewController.swift
//  RestAPIPractice
//
//  Created by iOS Training on 12/4/18.
//  Copyright © 2018 iOS Training. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Mark IBoutlets
    
    @IBOutlet weak var TextFieldUsername: UITextField!
    
    @IBOutlet weak var TextFieldPassword: UITextField!
    
    //Mark life cycle
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    //Private Methods
    private func validateFields() -> Bool {
        var status = true
        if let userNameText = TextFieldUsername.text, userNameText.count <= 0 {
            status = false
            self.showAlertMessage("Error", "Please enter non-empty username")
        } else if let PasswordText = TextFieldPassword.text, PasswordText.count <= 0 {
            status = false
            self.showAlertMessage("Error", "Please enter non-empty password")
        } else if !self.validateEmailId(TextFieldUsername.text!) {
            status = false
            self.showAlertMessage("Error", "Please enter vaild email")
        }
        return status
    }
    
    private func validateEmailId(_ emailId: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
    }
    
    private func showAlertMessage(_ title:String, _ message: String) {
        let alertPresenter = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
        }
        alertPresenter.addAction(okAction)
        self.present(alertPresenter, animated: true, completion: nil)
    }
    //Mark action methods
    
    @IBAction func OnClickofLoginButton(_ sender: Any) {
        
        if validateFields() {
            //Hit the login API
            self.showAlertMessage("Success", "Validation successfull")
        }
        
    }
    
    @IBAction func onClickOfSignUpButton(_ sender: Any) {
        let currentStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SignUpViewController = currentStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        //self.present(secondViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(SignUpViewController, animated: true)
        
        
        
    }
    
}



