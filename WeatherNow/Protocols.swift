//
//  Protocols.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

// MARK: - Weather Service Protocol
@preconcurrency
protocol WeatherServiceProtocol: ObservableObject {
    var currentWeather: ProcessedCurrentWeather? { get }
    var hourlyForecast: [ProcessedHourlyWeather] { get }
    var dailyForecast: [ProcessedDailyWeather] { get }
    var location: Location? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func requestLocation()
    func loadWeatherWithDefaultLocation()
}

// MARK: - Location Service Protocol
protocol LocationServiceProtocol {
    func requestLocation()
    func getCurrentLocation() async throws -> CLLocation
    func reverseGeocode(location: CLLocation) async throws -> Location
}

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func fetch<T: Codable>(_ type: T.Type, from url: URL) async throws -> T
}

// MARK: - Weather Formatter Protocol
protocol WeatherFormatterProtocol {
    func formatTemperature(_ temperature: Double) -> String
    func formatDate(_ timestamp: TimeInterval) -> String
    func formatTime(_ timestamp: TimeInterval) -> String
    func formatHourlyTime(_ timestamp: TimeInterval) -> String
    func getWeatherIcon(for code: String) -> String
    func getWeatherColor(for code: String) -> String
    func getWeatherColorAsColor(for code: String) -> Color
}

// MARK: - Error Types
enum WeatherError: LocalizedError {
    case networkError(String)
    case locationError(String)
    case decodingError(String)
    case invalidResponse(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .locationError(let message):
            return "Location error: \(message)"
        case .decodingError(let message):
            return "Data error: \(message)"
        case .invalidResponse(let message):
            return "Invalid response: \(message)"
        }
    }
}
