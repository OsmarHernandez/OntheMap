//
//  LocationViewController.swift
//  OntheMap
//
//  Created by Osmar Hernández on 26/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func finishTapped(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension LocationViewController: MKMapViewDelegate {
    
}
