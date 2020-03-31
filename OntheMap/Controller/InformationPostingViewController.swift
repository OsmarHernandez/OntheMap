//
//  InformationPostingViewController.swift
//  OntheMap
//
//  Created by Osmar Hernández on 26/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

private let showLocationIdentifier = "showLocation"

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: CustomTextField!
    @IBOutlet weak var linkTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLeftBarButtonFont()
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        guard let location = locationTextField.text, !location.isEmpty else { return }
        
        guard let link = linkTextField.text, !link.isEmpty else { return }
        
        let info = (location, link)
        
        performSegue(withIdentifier: showLocationIdentifier, sender: info)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        dismissKeyboard(for: locationTextField, and: linkTextField)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationViewController = segue.destination as? LocationViewController {
            locationViewController.studentInfo = sender as! (String, String)
        }
    }
}

extension InformationPostingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeFirstResponder(of: textField, with: locationTextField, and: linkTextField)
        
        return true
    }
}
