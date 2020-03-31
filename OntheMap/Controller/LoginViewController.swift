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
        
        UdacityAPI.login(user, completion: handeLoginResponse(_:error:))
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        dismissKeyboard(for: emailTextField, and: passwordTextField)
    }
    
    private func handeLoginResponse(_ success: Bool, error: Error?) {
        if success {
            UdacityAPI.getStudentLocations(completion: handleStudentLocationsResponse(_:error:))
        } else {
            print(error!)
        }
    }
    
    private func handleStudentLocationsResponse(_ locations: [StudentLocation], error: Error?) {
        guard error == nil else { return }
        
        LocationsSingleton.shared.locations = locations
        performSegue(withIdentifier: showMapIdentifier, sender: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeFirstResponder(of: textField, with: emailTextField, and: passwordTextField)
        
        return true
    }
}
