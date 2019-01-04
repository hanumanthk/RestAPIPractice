//
//  SignUpViewController.swift
//  RestAPIPractice
//
//  Created by iOS Training on 12/8/18.
//  Copyright © 2018 iOS Training. All rights reserved.
//

import UIKit

let SIGN_UP_API_URL = "https;://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyB7qnakdix7_4qr0rD39mwxSuOVbxcfbv4"

class SignUpViewController: UIViewController {
    @IBOutlet weak var txtFieldName: UITextField!
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func validateFields() -> Bool {
        var status = true
        if let userNameText = txtFieldName.text, userNameText.count <= 0 {
            status = false
            self.showAlertMessage("Error", "Please enter non-empty username") {
                
            }
        } else if let EmailText = txtFieldEmail.text, EmailText.count <= 0 {
            status = false
            self.showAlertMessage("Error", "Please enter valid email id") {
                
            }
        } else if !validateEmailId(txtFieldEmail.text!) {
            status = false
            self.showAlertMessage("Error", "Please enter valid email address") {}
        } else if let PasswordText = txtFieldPassword.text, PasswordText.count <= 0 {
            status = false
            self.showAlertMessage("Error", "Please enter non-empty password"){}
        } else if !validatePassword(txtFieldPassword.text!) {
            status = false
            self.showAlertMessage("Error", "Please enter valid password"){}
        } else if let ConfirmPasswordText =  txtFieldConfirmPassword.text, ConfirmPasswordText.count <= 0 {
            status = false
            self.showAlertMessage("Error", "pleaswe enter non empty confirm password"){}
        } else if !validateConfirmPassword(txtFieldConfirmPassword.text!) {
            status = false
            self.showAlertMessage("Error", "pleaswe enter valid password"){}
        } else if txtFieldConfirmPassword.text != txtFieldPassword.text {
            status = false
            self.showAlertMessage("Error", "Confirm password not matching password"){}
        }
        return status
    }
    
    
    private func validateEmailId(_ emailId: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
    }
    
    private func validatePassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    private func validateConfirmPassword(_ ConfirmPassword: String) -> Bool {
        let ConfirmPasswordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        
        let ConfirmPasswordTest = NSPredicate(format:"SELF MATCHES %@", ConfirmPasswordRegEx)
        return ConfirmPasswordTest.evaluate(with: ConfirmPassword)
    }
    
    private func showAlertMessage(_ title: String,_ message: String, withOkHandler okClosure: @escaping() -> Void) {
        let alertPresenter = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "ok", style: .default) { (action) in
            okClosure()
        }
        alertPresenter.addAction(okAction)
        self.present(alertPresenter, animated: true, completion: nil)
    }
    
    @IBAction func onClickOfSignUpButton(_ sender: Any) {
        self.view.endEditing(true)
        
        if validateFields() {
            
            self.hitSignUpAPI()
            
            
            //Hit the login API
        }
    }
    
    func moveToHomeScreen() {
        let currentStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController = currentStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.popToViewController(LoginViewController, animated: true)
    }
}


extension SignUpViewController {
    private func prepareSignUpAPIBody(_ emailId: String, _ password: String, _ name: String) -> Data? {
        let postBodyString = "{\"email\":\"\(emailId)\",\"password\":\"\(password)\",\"returnSecureToken\":true}"
        let dataBody = postBodyString.data(using: .utf8)
        return dataBody
    }
    
    private func prepareSignUpAPIBodyUsingCodable(_ emailId: String, _ password: String, _ name: String) -> Data? {
        let SignUpRequest = SignUpRequestModel.init(email: emailId, password: password, returnSecureToken: true)
        let jsonEncoder = JSONEncoder.init()
        do {
            let encodedData = try jsonEncoder.encode(SignUpRequest)
            return encodedData
        } catch (let error) {
            print("Error in encoding the data")
        }
        
        return nil
    }
    
    private func hitSignUpAPI() {
        //1
        if let url = URL.init(string:  SIGN_UP_API_URL) {
            var urlRequest = URLRequest.init(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.allHTTPHeaderFields = ["Content-Type" : "application/json"]
            urlRequest.httpBody = prepareSignUpAPIBodyUsingCodable(txtFieldEmail.text!, txtFieldPassword.text!, txtFieldName.text!)
            
            let requestString = String.init(data: prepareSignUpAPIBodyUsingCodable(txtFieldEmail.text!,txtFieldName.text!, txtFieldPassword.text!)!, encoding: String.Encoding.utf8)
            
            //2
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                
                DispatchQueue.main.async {
                    
                }
                
                //Handle The Response
                if let anyErrorObj = error {
                    print("Error Occured - \(anyErrorObj)")
                    return
                }
                
                guard let dataObject = data else {
                    return
                }
                
                if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 {
                    let SignUpResponseObject = self.parseSignUpResponseManually(withData: dataObject)
                    self.showAlertMessage("Success","SignUp Successfull with token \n \(SignUpResponseObject?.refreshToken ?? "")") {
                        self.moveToHomeScreen()
                        print("Ok Clicked!!!!! so now you move to home screen")
                    }
                } else {
                    let errorResponse = self.parseErrorResponseModelManually(withData: dataObject)
                    self.showAlertMessage("Error", errorResponse?.error.message ?? "") {
                    }
                }
                
                /*     self.showAlertMessage("Success", "SignUp Successfull")
                 } else {
                 self.showAlertMessage("Success", "SignUp UnSuccessfull")
                 }
                 
                 let responseString = String.init(data: dataObject, encoding: String.Encoding.utf8)
                 print("Hey we got the response -- \n  \(String(describing: responseString))")
                 }*/
            }
            dataTask.resume()
        }
    }
}



extension SignUpViewController {
    func parseSignUpResponse(withData data:Data) -> SignUpResponseModel? {
        let decoderObject = JSONDecoder.init()
        do {
            let SignUpResponse = try decoderObject.decode(SignUpResponseModel.self, from: data)
            return SignUpResponse
        } catch (let error) {
            print("Unable to parse the data with error \(error)")
        }
        
        return nil
    }
    
    func parseSignUpErrorResponse(withData data:Data) -> SignUpErrorResponseModel? {
        let decoderObject = JSONDecoder.init()
        do {
            let SignUpResponse = try decoderObject.decode(SignUpErrorResponseModel.self, from: data)
            return SignUpResponse
        } catch (let error) {
            print("Unable to parse the data with error \(error)")
        }
        
        return nil
    }
    
    func parseSignUpResponseManually(withData data:Data) -> SignUpResponseModel? {
        
        do {
            let dataDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("SignUp Response Data Dictionary -- \(dataDictionary)")
            
            var responseSignUp = SignUpResponseModel()
            
            if let dictResponseData = dataDictionary as? [String : Any] {
                
                responseSignUp.kind = dictResponseData["kind"] as! String
                responseSignUp.localId = dictResponseData["localId"] as! String
                responseSignUp.email = dictResponseData["email"] as! String
                responseSignUp.displayName = dictResponseData["displayName"] as! String
                responseSignUp.idToken = dictResponseData["idToken"] as! String
                responseSignUp.registered = dictResponseData["registered"] as! Bool
                responseSignUp.refreshToken = dictResponseData["refreshToken"] as! String
                responseSignUp.expiresIn = dictResponseData["expiresIn"] as! String
                return responseSignUp
            }
        } catch (let jsonError) {
            print("Failed to parse \(jsonError)")
        }
        
        return nil
    }
    
    func parseErrorResponseModelManually(withData data: Data) -> SignUpErrorResponseModel? {
        var signUpErrorResponseModel = SignUpErrorResponseModel()
        do {
            let errorDataDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let dictErrorResponse = errorDataDictionary as? [String : Any] {
                if let dictError = dictErrorResponse["error"] as? [String: Any] {
                    signUpErrorResponseModel.error.code = dictError["code"] as! Int
                    signUpErrorResponseModel.error.message = dictError["message"] as! String
                    
                    if let arrayError = dictError["errors"] as? [[String: Any]] {
                        if let dictErrorMessage = arrayError[0] as? [String: Any] {
                            var signUpError = SignUpError()
                            signUpError.domain = dictErrorMessage["domain"] as! String
                            signUpError.message = dictErrorMessage["message"] as! String
                            signUpError.reason = dictErrorMessage["reason"] as! String
                            
                            signUpErrorResponseModel.error.errors = [signUpError]
                        }
                    }
                    return signUpErrorResponseModel
                }
            }
        } catch (let error) {
            print("Failed to parse the error response with error \(error)")
        }
        
        return nil
    }
}















