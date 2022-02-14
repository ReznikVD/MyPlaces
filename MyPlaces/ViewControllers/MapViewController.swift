//
//  MapViewController.swift
//  MyPlaces
//
//  Created by user207855 on 2/9/22.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllDelegate {
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
    
    let mapManger = MapManager()
    var mapViewControllDelegate: MapViewControllDelegate?
    var place =  Place()
    
    let annotationIdentifier = "annotationIdentifier"
    var incomeSegueIdentifier = ""
    
    var previousLocation: CLLocation? {
        didSet {
            mapManger.startTrackingUserLocation(
                for: mapView,
                and: previousLocation) { currentLocation in
                    self.previousLocation = currentLocation
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.mapManger.showUserLocation(mapView: self.mapView)
                    }
            }
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapPinImaage: UIImageView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = ""
        mapView.delegate = self
        setupMapView()
    }
    
    @IBAction func centerViewUserLocation() {
        mapManger.showUserLocation(mapView: mapView)
    }
    
    @IBAction func doneButtonPressed() {
        mapViewControllDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true)
    }
    
    
    @IBAction func goButtonPressed() {
        mapManger.getDirections(for: mapView) { (location) in
            self.previousLocation = location
        }
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    private func setupMapView() {
        
        goButton.isHidden = true
        
        mapManger.checkLocationServices(mapView: mapView, segueIdentifier: incomeSegueIdentifier) {
            mapManger.locationManager.delegate = self
        }
        
        if incomeSegueIdentifier == "showPlace" {
            mapManger.setupPlaceMark(place: place, mapView: mapView)
            mapPinImaage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapManger.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == "showPlace" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManger.showUserLocation(mapView: self.mapView)
            }
        }
        
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            let streetNmae = placemark?.thoroughfare
            let buildName = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                
                if streetNmae != nil && buildName != nil {
                    self.addressLabel.text = "\(streetNmae!), \(buildName!)"
                } else if streetNmae != nil {
                    self.addressLabel.text = "\(streetNmae!)"
                } else {
                    self.addressLabel.text = ""
                }
                
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager,
                                               didChnageAuthorization status: CLAuthorizationStatus) {
        
        mapManger.checkLocationAuthorization(mapView: mapView,
                                             segueIdentifier: incomeSegueIdentifier)
    }
    
}
