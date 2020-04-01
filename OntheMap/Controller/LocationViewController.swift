//
//  LocationViewController.swift
//  OntheMap
//
//  Created by Osmar Hernández on 26/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import MapKit

private let pinIdentifier = "pin"

class LocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationRequest: CreateLocationRequest!
    var studentInfo: (location: String, link: String)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchForLocation(studentInfo.location, completion: handleSearchLocation(_:error:))
    }
    
    private func searchForLocation(_ location: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = studentInfo.location
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            for item in response.mapItems {
                completion(item.placemark.coordinate, nil)
            }
        }
    }
    
    private func newStudentLocationRequest(lat: Double, long: Double) -> CreateLocationRequest {
        let dictionary: [String : Any] = [
            "uniqueKey" : "\(UdacityAPI.Auth.key)",
            "firstName" : "John",
            "lastName" : "Doe",
            "mapString" : studentInfo.location,
            "mediaURL" : studentInfo.link,
            "latitude" : lat,
            "longitude" : long
        ]
        
        return CreateLocationRequest(dictionary: dictionary)
    }
    
    private func handleSearchLocation(_ coordinate: CLLocationCoordinate2D?, error: Error?) {
        guard let coordinate = coordinate else { return }
        
        locationRequest = newStudentLocationRequest(lat: coordinate.latitude, long: coordinate.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = locationRequest.firstName + " " + locationRequest.lastName
        annotation.subtitle = locationRequest.mediaURL
        
        mapView.addAnnotation(annotation)
        mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2_00_000.0, longitudinalMeters: 2_00_000.0)
    }

    @IBAction func finishTapped(_ sender: UIButton) {
        if UdacityAPI.Auth.objectId == "" {
            UdacityAPI.createStudentLocation(locationRequest: locationRequest, completion: handleLocationRequest(_:error:))
        } else {
            UdacityAPI.updateStudentLocation(objectId: UdacityAPI.Auth.objectId, locationRequest: locationRequest, completion: handleLocationRequest(_:error:))
        }
    }
    
    private func handleLocationRequest(_ success: Bool, error: Error?) {
        let message = UdacityAPI.Auth.objectId == "" ? "sent!" : "updated!"
        let title = UdacityAPI.Auth.objectId == "" ? "Sumbitting" : "Updating"
        
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        if let error = error {
            showAlertController(title: "\(title) Location", message: "Something went wrong. \(error)", alertActions: [alertAction])
        } else {
            showAlertController(title: "\(title) Location", message: "Your location has been successfully \(message)", alertActions: [alertAction])
        }
        
        if success {
            updateStudentLocationsData()
        }
    }
}

extension LocationViewController: MKMapViewDelegate {
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
}
