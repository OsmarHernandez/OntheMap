//
//  LoginViewController.swift
//  OntheMap
//
//  Created by Osmar Hernández on 26/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

private let showMapIdentifier = "showMap"

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTextFieldToInitialState(emailTextField, placeholder: "Email")
        setTextFieldToInitialState(passwordTextField, placeholder: "Password")
    }
    
    private func setTextFieldToInitialState(_ textField: UITextField, placeholder: String) {
        textField.text = ""
        textField.placeholder = placeholder
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let username = emailTextField.text!
        let password = passwordTextField.text!
        
        let user = User(username: username, password: password)
        
        setLoggingIn(true)
        UdacityAPI.login(user, completion: handeLoginResponse(_:error:))
    }
    
    @IBAction func loginViaWebsiteTapped(_ sender: UIButton) {
        UIApplication.shared.open(UdacityAPI.Endpoints.signup.url, options: [:], completionHandler: nil)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        dismissKeyboard(for: emailTextField, and: passwordTextField)
    }
    
    private func handeLoginResponse(_ success: Bool, error: Error?) {
        setLoggingIn(false)
        
        if success {
            UdacityAPI.getStudentLocations(completion: handleStudentLocationsResponse(_:error:))
        } else {
            showAlertController(title: "Wrong Credentials", message: "Either the username or password is incorrect.", alertActions: [alertActionForWrongCredentials])
        }
    }
    
    private func handleStudentLocationsResponse(_ locations: [StudentLocation], error: Error?) {
        guard error == nil else { return }
        
        LocationsSingleton.shared.locations = locations
        performSegue(withIdentifier: showMapIdentifier, sender: nil)
    }
    
    private func setLoggingIn(_ loggingIn: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.emailTextField.isHidden = loggingIn
            self.passwordTextField.isHidden = loggingIn
            self.loginViaWebsiteButton.isEnabled = !loggingIn
            
            if loggingIn {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private let alertActionForWrongCredentials: UIAlertAction = {
        return UIAlertAction(title: "Try again", style: .default, handler: nil)
    }()
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeFirstResponder(of: textField, with: emailTextField, and: passwordTextField)
        
        return true
    }
}
