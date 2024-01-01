//
//  MapControllerViewController.swift
//  CalorieRow
//
//  Created by Daniel Salas on 11/14/21.
//

import UIKit
import MapKit
import CoreLocation



class MapControllerViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerButton: UIBarButtonItem!
    @IBOutlet weak var addressLabel: UILabel!

    
    
    let locationManager:CLLocationManager = CLLocationManager()
    let regionInMeter:Double = 10000
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        previousLocation = getCenterLocation(for: mapView)

    }
    
    
    
    @IBAction func centerOnView(_ sender: Any) {
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
           let latitude = mapView.centerCoordinate.latitude
           let longitude = mapView.centerCoordinate.longitude
           
           return CLLocation(latitude: latitude, longitude: longitude)
       }
    
    
    
    @IBAction func selectWorkoutButton(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Location Selected", message: "\(self.addressLabel!.text!) has been selected. Do you want to add this to your workout log?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:
        {
            action in print("cool")
            let newAddress = WorkoutLocation(context: self.context)
            
            newAddress.address = self.addressLabel!.text
            
            
            do{
            try self.context.save()
            }catch{
                print("an error has occured")
            }
            
            
            print(newAddress.address!)
            self.performSegue(withIdentifier: "mapsBack", sender: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))
        
        
        present(alert, animated: true)
        
        
        
        
    }
    
    
    
}


extension MapControllerViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        let geoCode = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else {return}
        
        guard center.distance(from: previousLocation) > 50 else {return}
        self.previousLocation = center
        
    
                
                geoCode.reverseGeocodeLocation(center) {
                    [weak self] (placemarks, error) in
                    guard let self = self else { return }
                    
                    if let _ = error {
                        //TODO: Show alert informing the user
                        return
                    }
                    
                    guard let placemark = placemarks?.first else {
                        //TODO: Show alert informing the user
                        return
                    }
                    
                    let streetNumber = placemark.subThoroughfare ?? ""
                    let streetName = placemark.thoroughfare ?? ""
                    
                    DispatchQueue.main.async {
                        self.addressLabel.text = "\(streetNumber) \(streetName)"
                    }
                }
        
       
    }
}
