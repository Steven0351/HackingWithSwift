//
//  ViewController.swift
//  CapitalCities
//
//  Created by Steven Sherry on 7/8/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London",
                             coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                             info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo",
                           coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
                           info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris",
                            coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
                            info: "Often called the city of light.")
        let rome = Capital(title: "Rome",
                           coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
                           info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC",
                                 coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667),
                                 info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self,
                                                            action: #selector(changeMapView))
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Capital"
        
        if annotation is Capital {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            
            if annotationView == nil {
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
                
                let favorite = UIButton(type: .contactAdd)
                annotationView!.leftCalloutAccessoryView = favorite
            } else {
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let capital = view.annotation as! Capital
            let placeName = capital.title
            let placeInfo = capital.info
            
            let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Add Favorite?", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                let pinView = view as? MKPinAnnotationView
                pinView?.pinTintColor = .green
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                let pinView = view as? MKPinAnnotationView
                pinView?.pinTintColor = .red
            })
            present(ac, animated: true)
        }
        
    }
    
    func changeMapView() {
        let ac = UIAlertController(title: "Choose your map type: ", message: nil,
                                   preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { [unowned self] _ in
            self.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Sattelite", style: .default) { [unowned self] _ in
            self.mapView.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { [unowned self] _ in
            self.mapView.mapType = .hybrid
        })
        
        present(ac, animated: true)
    }

}

