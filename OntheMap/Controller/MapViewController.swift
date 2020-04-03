//
//  MapViewController.swift
//  OntheMap
//
//  Created by Osmar Hernández on 26/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import MapKit

private let pinIdentifier = "pin"

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLeftBarButtonFont()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: updateLocationsDataNotification, object: nil)
    }
    
    @objc func updateView() {
        configureUI()
    }
    
    private func configureUI() {
        var annotations = mapView.annotations
        
        if !mapView.annotations.isEmpty {
            mapView.removeAnnotations(annotations)
        }
        
        annotations = setupAnnotations()
        mapView.addAnnotations(annotations)
    }
    
    private func setupAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        
        for location in Locations.shared.results {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.firstName + " " + location.lastName
            annotation.subtitle = location.mediaURL
            
            annotations.append(annotation)
        }
        
       return annotations
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [ : ], completionHandler: nil)
            }
        }
    }
}
