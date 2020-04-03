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
        
        setupAnimationView(activityIndicator, isAnimating: true, textfields: [emailTextField, passwordTextField], buttons: [loginButton, loginViaWebsiteButton])
        UdacityAPI.login(user, completion: handeLoginResponse(_:error:))
    }
    
    @IBAction func loginViaWebsiteTapped(_ sender: UIButton) {
        UIApplication.shared.open(UdacityAPI.Endpoints.signup.url, options: [:], completionHandler: nil)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        dismissKeyboard(for: emailTextField, and: passwordTextField)
    }
    
    private func handeLoginResponse(_ success: Bool, error: Error?) {
        setupAnimationView(activityIndicator, isAnimating: false, textfields: [emailTextField, passwordTextField], buttons: [loginButton, loginViaWebsiteButton])
        
        if success {
            UdacityAPI.getStudentLocations(completion: handleStudentLocationsResponse(_:error:))
        } else {
            let alertActionForWrongCredentials = defaultAlertAction("Try again")
            showAlertController(title: "Failed login attempt", message: error?.localizedDescription, alertActions: [alertActionForWrongCredentials])
        }
    }
    
    private func handleStudentLocationsResponse(_ locations: [StudentLocation], error: Error?) {
        guard error == nil else {
            let alertActionForLocationsRequestFailure = defaultAlertAction("Ok")
            showAlertController(title: "Failed to fetch data", message: error?.localizedDescription, alertActions: [alertActionForLocationsRequestFailure])
            return
        }
        
        Locations.shared.results = locations
        performSegue(withIdentifier: showMapIdentifier, sender: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeFirstResponder(of: textField, with: emailTextField, and: passwordTextField)
        
        return true
    }
}
