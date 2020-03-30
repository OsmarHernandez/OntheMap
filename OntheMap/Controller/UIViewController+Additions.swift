//
//  UIViewController+Additions.swift
//  OntheMap
//
//  Created by Osmar Hernández on 26/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var updateLocationsDataNotification: Notification.Name {
        return Notification.Name("view.reloadData")
    }
    
    func dismissKeyboard(for firstTextField: UITextField, and secondTextField: UITextField) {
        if firstTextField.isFirstResponder {
            firstTextField.resignFirstResponder()
        } else if secondTextField.isFirstResponder {
            secondTextField.resignFirstResponder()
        }
    }
    
    func changeFirstResponder(of currentTextField: UITextField, with firstTextField: UITextField, and secondTextField: UITextField) {
        if currentTextField == firstTextField {
            secondTextField.becomeFirstResponder()
        } else {
            currentTextField.resignFirstResponder()
        }
    }
    
    func changeLeftBarButtonFont() {
        if let leftBarButtonItem = navigationItem.leftBarButtonItem {
            leftBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15.0)], for: .normal)
            leftBarButtonItem.title = leftBarButtonItem.title?.uppercased()
        }
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityAPI.logout { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        UdacityAPI.getUpdate { (locations, error) in
            guard !locations.isEmpty else { return }
            
            LocationsSingleton.shared.locations = locations
            
            NotificationCenter.default.post(name: self.updateLocationsDataNotification, object: nil)
        }
    }
}
