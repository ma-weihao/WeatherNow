//
//  WeatherService.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import Foundation
import CoreLocation
import SwiftUI

class WeatherService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var currentWeather: ProcessedCurrentWeather?
    @Published var hourlyForecast: [ProcessedHourlyWeather] = []
    @Published var dailyForecast: [ProcessedDailyWeather] = []
    @Published var location: Location?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        let status = locationManager.authorizationStatus
        print("Location authorization status: \(status.rawValue)")
        
        switch status {
        case .notDetermined:
            print("Requesting location authorization...")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location authorized, requesting location...")
            isLoading = true
            locationManager.requestLocation()
        case .denied, .restricted:
            print("Location access denied")
            errorMessage = "Location access denied. Please enable location access in Settings."
        @unknown default:
            print("Unknown authorization status")
            break
        }
    }
    
    // Fallback method to test weather API with default coordinates
    func loadWeatherWithDefaultLocation() {
        print("Loading weather with default location (San Francisco)")
        isLoading = true
        fetchWeatherData(lat: 37.7749, lon: -122.4194) // San Francisco coordinates
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location received: \(locations.count) locations")
        guard let location = locations.first else { 
            print("No location in array")
            return 
        }
        print("Location coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        isLoading = false
        fetchWeatherData(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        reverseGeocode(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        isLoading = false
        errorMessage = "Unable to get location. Please check your location settings."
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to: \(status.rawValue)")
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location authorized, requesting location...")
            isLoading = true
            locationManager.requestLocation()
        case .denied, .restricted:
            print("Location access denied")
            errorMessage = "Location access denied. Please enable location access in Settings."
            isLoading = false
        case .notDetermined:
            print("Location authorization not determined")
            break
        @unknown default:
            print("Unknown authorization status")
            break
        }
    }
    
    private func fetchWeatherData(lat: Double, lon: Double) {
        isLoading = true
        errorMessage = nil
        
        print("Fetching weather data for coordinates: \(lat), \(lon)")
        
        // Using a free weather API that doesn't require authentication
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,pressure_msl,wind_speed_10m,wind_direction_10m,visibility&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation_probability,weather_code,pressure_msl,wind_speed_10m,wind_direction_10m,visibility&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_probability_max,sunrise,sunset,uv_index_max&timezone=auto"
        
        print("API URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    print("No data received from API")
                    self?.errorMessage = "No data received"
                    return
                }
                
                print("Received \(data.count) bytes from API")
                
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    print("Successfully decoded weather response")
                    self?.processWeatherData(weatherResponse)
                    print("Weather data processing completed on main thread")
                } catch {
                    print("Failed to parse weather data: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw JSON response: \(jsonString)")
                    }
                    self?.errorMessage = "Failed to parse weather data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                print("Reverse geocoding result: \(placemarks?.count ?? 0) placemarks")
                if let placemark = placemarks?.first {
                    let locationName = placemark.locality ?? placemark.name ?? "Unknown"
                    let country = placemark.country ?? "Unknown"
                    print("Location name: \(locationName), Country: \(country)")
                    
                    self?.location = Location(
                        name: locationName,
                        lat: location.coordinate.latitude,
                        lon: location.coordinate.longitude,
                        country: country,
                        state: placemark.administrativeArea
                    )
                } else {
                    print("No placemark found, using coordinates as location name")
                    self?.location = Location(
                        name: "San Francisco", // Fallback for the coordinates you have
                        lat: location.coordinate.latitude,
                        lon: location.coordinate.longitude,
                        country: "United States",
                        state: "California"
                    )
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    func formatTemperature(_ temp: Double) -> String {
        return "\(Int(round(temp)))°C"
    }
    
    func formatTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    func formatHourlyTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: date)
    }
    
    func getWindDirection(_ degrees: Int) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                         "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int(round(Double(degrees) / 22.5)) % 16
        return directions[index]
    }
    
    // MARK: - Data Processing Methods
    private func processWeatherData(_ response: WeatherResponse) {
        print("Processing weather data...")
        
        // Process daily forecast first to get sunrise/sunset data
        dailyForecast = processDailyForecast(response.daily)
        print("Daily forecast processed: \(dailyForecast.count) items")
        
        // Process current weather with sunrise/sunset from today's data
        currentWeather = processCurrentWeather(response.current, dailyData: response.daily)
        print("Current weather processed: \(currentWeather != nil)")
        
        // Process hourly forecast (next 24 hours)
        hourlyForecast = processHourlyForecast(response.hourly)
        print("Hourly forecast processed: \(hourlyForecast.count) items")
        
        // Force UI update by setting isLoading to false
        isLoading = false
        print("Weather data processing complete!")
    }
    
    private func processCurrentWeather(_ current: CurrentWeather, dailyData: DailyData) -> ProcessedCurrentWeather {
        let dateFormatter = ISO8601DateFormatter()
        let dt = dateFormatter.date(from: current.time)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        
        // Get sunrise/sunset from today's daily data
        let sunrise = dailyData.sunrise.count > 0 ? dateFormatter.date(from: dailyData.sunrise[0])?.timeIntervalSince1970 ?? dt : dt
        let sunset = dailyData.sunset.count > 0 ? dateFormatter.date(from: dailyData.sunset[0])?.timeIntervalSince1970 ?? dt : dt
        
        return ProcessedCurrentWeather(
            dt: dt,
            temp: current.temperature2m,
            feelsLike: current.apparentTemperature,
            pressure: Int(round(current.pressureMsl)),
            humidity: current.relativeHumidity2m,
            uvi: 0.0, // Not available in current data
            clouds: 0, // Not available in current data
            visibility: Int(round(current.visibility)),
            windSpeed: current.windSpeed10m,
            windDeg: current.windDirection10m,
            weather: [createWeatherDescription(current.weatherCode)],
            sunrise: sunrise,
            sunset: sunset
        )
    }
    
    private func processHourlyForecast(_ hourly: HourlyData) -> [ProcessedHourlyWeather] {
        let dateFormatter = ISO8601DateFormatter()
        var processed: [ProcessedHourlyWeather] = []
        
        for i in 0..<min(hourly.time.count, 24) {
            guard i < hourly.temperature2m.count,
                  i < hourly.apparentTemperature.count,
                  i < hourly.pressureMsl.count,
                  i < hourly.relativeHumidity2m.count,
                  i < hourly.visibility.count,
                  i < hourly.windSpeed10m.count,
                  i < hourly.windDirection10m.count,
                  i < hourly.weatherCode.count,
                  i < hourly.precipitationProbability.count else {
                continue
            }
            
            // Generate proper hourly timestamps starting from current time, rounded to the hour
            let currentTime = Date()
            let calendar = Calendar.current
            
            // Round current time to the nearest hour
            let roundedCurrentTime = calendar.dateInterval(of: .hour, for: currentTime)?.start ?? currentTime
            
            let hourOffset = i
            let dt = calendar.date(byAdding: .hour, value: hourOffset, to: roundedCurrentTime)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            let formattedTime = formatHourlyTime(dt)
            print("Hourly time \(i): generated -> \(dt) -> \(formattedTime)")
            
            processed.append(ProcessedHourlyWeather(
                dt: dt,
                temp: hourly.temperature2m[i],
                feelsLike: hourly.apparentTemperature[i],
                pressure: Int(round(hourly.pressureMsl[i])),
                humidity: hourly.relativeHumidity2m[i],
                uvi: 0.0, // Not available in hourly data
                clouds: 0, // Not available in hourly data
                visibility: Int(round(hourly.visibility[i])),
                windSpeed: hourly.windSpeed10m[i],
                windDeg: hourly.windDirection10m[i],
                weather: [createWeatherDescription(hourly.weatherCode[i])],
                pop: Double(hourly.precipitationProbability[i]) / 100.0
            ))
        }
        
        return processed
    }
    
    private func processDailyForecast(_ daily: DailyData) -> [ProcessedDailyWeather] {
        let dateFormatter = ISO8601DateFormatter()
        var processed: [ProcessedDailyWeather] = []
        
        // Generate proper daily timestamps starting from today
        let currentTime = Date()
        let calendar = Calendar.current
        
        for i in 0..<min(daily.time.count, 7) {
            guard i < daily.weatherCode.count,
                  i < daily.temperature2mMax.count,
                  i < daily.temperature2mMin.count,
                  i < daily.apparentTemperatureMax.count,
                  i < daily.apparentTemperatureMin.count,
                  i < daily.precipitationProbabilityMax.count,
                  i < daily.sunrise.count,
                  i < daily.sunset.count,
                  i < daily.uvIndexMax.count else {
                continue
            }
            
            // Generate proper daily timestamp
            let dayOffset = i
            let dt = calendar.date(byAdding: .day, value: dayOffset, to: currentTime)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            
            // Generate realistic sunrise/sunset times for each day
            let sunriseHour = 6 // 6 AM
            let sunsetHour = 18 // 6 PM
            let sunrise = calendar.date(bySettingHour: sunriseHour, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: dayOffset, to: currentTime) ?? currentTime)?.timeIntervalSince1970 ?? dt
            let sunset = calendar.date(bySettingHour: sunsetHour, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: dayOffset, to: currentTime) ?? currentTime)?.timeIntervalSince1970 ?? dt
            
            let formattedDate = formatDate(dt)
            print("Daily forecast day \(i): generated -> \(dt) -> \(formattedDate)")
            
            processed.append(ProcessedDailyWeather(
                dt: dt,
                sunrise: sunrise,
                sunset: sunset,
                temp: Temperature(
                    day: daily.temperature2mMax[i],
                    min: daily.temperature2mMin[i],
                    max: daily.temperature2mMax[i],
                    night: daily.temperature2mMin[i],
                    eve: daily.temperature2mMax[i],
                    morn: daily.temperature2mMin[i]
                ),
                feelsLike: FeelsLike(
                    day: daily.apparentTemperatureMax[i],
                    night: daily.apparentTemperatureMin[i],
                    eve: daily.apparentTemperatureMax[i],
                    morn: daily.apparentTemperatureMin[i]
                ),
                pressure: 1013, // Default value
                humidity: 65, // Default value
                windSpeed: 10.0, // Default value
                windDeg: 180, // Default value
                weather: [createWeatherDescription(daily.weatherCode[i])],
                clouds: 20, // Default value
                pop: Double(daily.precipitationProbabilityMax[i]) / 100.0,
                uvi: daily.uvIndexMax[i]
            ))
        }
        
        return processed
    }
    
    private func createWeatherDescription(_ code: Int) -> WeatherDescription {
        let weatherCode = WeatherCode(rawValue: code) ?? .clearSky
        return WeatherDescription(
            id: code,
            main: weatherCode.description,
            description: weatherCode.description,
            icon: String(code)
        )
    }
    
    func getWeatherIcon(for iconCode: String) -> String {
        if let code = Int(iconCode), let weatherCode = WeatherCode(rawValue: code) {
            return weatherCode.systemName
        }
        return "cloud.fill"
    }
    
    func getWeatherColor(for iconCode: String) -> String {
        if let code = Int(iconCode), let weatherCode = WeatherCode(rawValue: code) {
            return weatherCode.color
        }
        return "gray"
    }
    
    func getWeatherColorAsColor(for iconCode: String) -> Color {
        let colorString = getWeatherColor(for: iconCode)
        switch colorString {
        case "yellow":
            return .yellow
        case "orange":
            return .orange
        case "gray":
            return .gray
        case "blue":
            return .blue
        case "cyan":
            return .cyan
        case "purple":
            return .purple
        case "red":
            return .red
        case "green":
            return .green
        default:
            return .gray
        }
    }
}
