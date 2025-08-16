//
//  LocationService.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import Foundation
import CoreLocation

@MainActor
final class LocationService: NSObject, LocationServiceProtocol, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    @Published var locationName: Location?
    
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }
    
    func requestLocation() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }
    
    func getCurrentLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            
            switch authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation()
            case .denied, .restricted:
                continuation.resume(throwing: WeatherError.locationError("Location access denied"))
            @unknown default:
                continuation.resume(throwing: WeatherError.locationError("Unknown authorization status"))
            }
        }
    }
    
    func reverseGeocode(location: CLLocation) async throws -> Location {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else {
                throw WeatherError.locationError("No location found")
            }
            
            return Location(
                name: placemark.locality ?? "Unknown",
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude,
                country: placemark.country ?? "",
                state: placemark.administrativeArea
            )
        } catch {
            throw WeatherError.locationError("Failed to reverse geocode: \(error.localizedDescription)")
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: WeatherError.locationError(error.localizedDescription))
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            locationContinuation?.resume(throwing: WeatherError.locationError("Location access denied"))
            locationContinuation = nil
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
