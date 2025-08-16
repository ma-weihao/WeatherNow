//
//  WeatherService.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import Foundation
import CoreLocation
import SwiftUI

@MainActor
final class WeatherService: WeatherServiceProtocol {
    // MARK: - Dependencies
    private let locationService: LocationServiceProtocol
    private let weatherAPIService: WeatherAPIService
    private let weatherFormatter: WeatherFormatterProtocol
    
    // MARK: - Published Properties
    @Published var currentWeather: ProcessedCurrentWeather?
    @Published var hourlyForecast: [ProcessedHourlyWeather] = []
    @Published var dailyForecast: [ProcessedDailyWeather] = []
    @Published var location: Location?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Initialization
    init(
        locationService: LocationServiceProtocol,
        weatherAPIService: WeatherAPIService,
        weatherFormatter: WeatherFormatterProtocol
    ) {
        self.locationService = locationService
        self.weatherAPIService = weatherAPIService
        self.weatherFormatter = weatherFormatter
    }
    
    convenience init() {
        self.init(
            locationService: LocationService(),
            weatherAPIService: WeatherAPIService(),
            weatherFormatter: WeatherFormatter()
        )
    }
    
    // MARK: - Public Methods
    func requestLocation() {
        Task {
            await fetchWeatherForCurrentLocation()
        }
    }
    
    func loadWeatherWithDefaultLocation() {
        Task {
            await fetchWeatherData(
                lat: APIConfig.defaultLocation.lat,
                lon: APIConfig.defaultLocation.lon
            )
        }
    }
    
    // MARK: - Private Methods
    private func fetchWeatherForCurrentLocation() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let location = try await locationService.getCurrentLocation()
            let locationName = try await locationService.reverseGeocode(location: location)
            
            await fetchWeatherData(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            self.location = locationName
        } catch {
            await handleError(error)
        }
    }
    
               private func fetchWeatherData(lat: Double, lon: Double) async {
               isLoading = true
               errorMessage = nil
               
               do {
                   let weatherResponse = try await weatherAPIService.fetchWeather(lat: lat, lon: lon)
                   await processWeatherData(weatherResponse)
               } catch {
                   await handleError(error)
               }
           }
    
    private func processWeatherData(_ response: WeatherResponse) async {
        currentWeather = processCurrentWeather(response.current, dailyData: response.daily)
        hourlyForecast = processHourlyForecast(response.hourly)
        dailyForecast = processDailyForecast(response.daily)
        isLoading = false
    }
    
    private func handleError(_ error: Error) async {
        isLoading = false
        
        if let weatherError = error as? WeatherError {
            errorMessage = weatherError.localizedDescription
        } else {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Data Processing Methods
    private func processCurrentWeather(_ current: CurrentWeather, dailyData: DailyData) -> ProcessedCurrentWeather {
        let dt = ISO8601DateFormatter().date(from: current.time)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        
        // Get sunrise/sunset from today's daily data
        let dateFormatter = ISO8601DateFormatter()
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
    
    // MARK: - Formatter Delegation
    func formatTemperature(_ temperature: Double) -> String {
        return weatherFormatter.formatTemperature(temperature)
    }
    
    func formatTime(_ timestamp: TimeInterval) -> String {
        return weatherFormatter.formatTime(timestamp)
    }
    
    func formatHourlyTime(_ timestamp: TimeInterval) -> String {
        return weatherFormatter.formatHourlyTime(timestamp)
    }
    
    func formatDate(_ timestamp: TimeInterval) -> String {
        return weatherFormatter.formatDate(timestamp)
    }
    
    func getWeatherIcon(for iconCode: String) -> String {
        return weatherFormatter.getWeatherIcon(for: iconCode)
    }
    
    func getWeatherColor(for iconCode: String) -> String {
        return weatherFormatter.getWeatherColor(for: iconCode)
    }
    
    func getWeatherColorAsColor(for iconCode: String) -> Color {
        return weatherFormatter.getWeatherColorAsColor(for: iconCode)
    }
    
    func getWindDirection(_ degrees: Int) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                         "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int(round(Double(degrees) / 22.5)) % 16
        return directions[index]
    }
} 
