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
    }

    @IBAction func finishTapped(_ sender: UIButton) {
        if UdacityAPI.Auth.objectId == "" {
            print("create")
            UdacityAPI.create(studentRequest: locationRequest!, completion: handleCreateLocationRequest(success:error:))
        } else {
            print("update")
            UdacityAPI.update(objectId: UdacityAPI.Auth.objectId, studentRequest: locationRequest!, completion: handleUpdateRequest(success:error:))
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func handleCreateLocationRequest(success: Bool, error: Error?) {
        if success {
            print("Successfully created!")
        } else {
            print(error!)
        }
    }
    
    private func handleUpdateRequest(success: Bool, error: Error?) {
        if success {
            print("Successfully updated!")
        } else {
            print(error!)
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
