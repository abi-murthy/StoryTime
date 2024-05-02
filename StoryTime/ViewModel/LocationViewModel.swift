
import Foundation
import Combine
import CoreLocation

let manager = CLLocationManager()


class LocationViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastKnownLocation: CLLocation?

    
    override init() {
        super.init()
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
    }

    func requestPermission(){
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        lastKnownLocation = location

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error)")
    }
}

func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String) -> Void) {
    let geocoder = CLGeocoder()
    let location = CLLocation(latitude: latitude, longitude: longitude)
    
    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
        if let error = error {
            print("Error in reverse geocoding: \(error.localizedDescription)")
            completion("Error: \(error.localizedDescription)")
            return
        }
        
        guard let placemark = placemarks?.first else {
            completion("No address found.")
            return
        }
        
        var addressString = ""
        
        if let street = placemark.thoroughfare {
            addressString += street + ", "
        }
        if let city = placemark.locality {
            addressString += city + ", "
        }
        if let state = placemark.administrativeArea {
            addressString += state + " "
        }
        if let postalCode = placemark.postalCode {
            addressString += postalCode + ", "
        }
        if let country = placemark.country {
            addressString += country
        }
        
        completion(addressString)
    }
}
