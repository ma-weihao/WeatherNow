//
//  WeatherFormatter.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import Foundation
import SwiftUI

final class WeatherFormatter: WeatherFormatterProtocol {
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    private let hourlyTimeFormatter = DateFormatter()
    
    init() {
        setupFormatters()
    }
    
    private func setupFormatters() {
        dateFormatter.dateFormat = "E, MMM d"
        dateFormatter.timeZone = TimeZone.current
        
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.timeZone = TimeZone.current
        
        hourlyTimeFormatter.dateFormat = "HH:mm"
        hourlyTimeFormatter.timeZone = TimeZone.current
    }
    
    func formatTemperature(_ temperature: Double) -> String {
        return "\(Int(round(temperature)))°C"
    }
    
    func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return dateFormatter.string(from: date)
    }
    
    func formatTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return timeFormatter.string(from: date)
    }
    
    func formatHourlyTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return hourlyTimeFormatter.string(from: date)
    }
    
    func getWeatherIcon(for code: String) -> String {
        guard let intCode = Int(code),
              let weatherCode = WeatherCode(rawValue: intCode) else {
            return WeatherIcons.clearSky
        }
        
        switch weatherCode {
        case .clearSky:
            return WeatherIcons.clearSky
        case .mainlyClear, .partlyCloudy, .overcast:
            return WeatherIcons.partlyCloudy
        case .fog, .rimeFog:
            return WeatherIcons.fog
        case .drizzleLight, .drizzleModerate, .drizzleDense, .rainSlight, .rainModerate, .rainHeavy, .rainShowersSlight, .rainShowersModerate, .rainShowersViolent:
            return WeatherIcons.rain
        case .rainFreezingSlight, .rainFreezingHeavy, .snowSlight, .snowModerate, .snowHeavy, .snowGrains, .snowShowersSlight, .snowShowersHeavy:
            return WeatherIcons.snow
        case .thunderstormSlight, .thunderstormModerate, .thunderstormHeavy:
            return WeatherIcons.thunderstorm
        }
    }
    
    func getWeatherColor(for code: String) -> String {
        guard let intCode = Int(code),
              let weatherCode = WeatherCode(rawValue: intCode) else {
            return "yellow"
        }
        
        switch weatherCode {
        case .clearSky:
            return "yellow"
        case .mainlyClear, .partlyCloudy, .overcast:
            return "orange"
        case .fog, .rimeFog:
            return "gray"
        case .drizzleLight, .drizzleModerate, .drizzleDense, .rainSlight, .rainModerate, .rainHeavy, .rainShowersSlight, .rainShowersModerate, .rainShowersViolent:
            return "blue"
        case .rainFreezingSlight, .rainFreezingHeavy, .snowSlight, .snowModerate, .snowHeavy, .snowGrains, .snowShowersSlight, .snowShowersHeavy:
            return "cyan"
        case .thunderstormSlight, .thunderstormModerate, .thunderstormHeavy:
            return "purple"
        }
    }
    
    func getWeatherColorAsColor(for code: String) -> Color {
        let colorString = getWeatherColor(for: code)
        
        switch colorString {
        case "yellow":
            return .yellow
        case "orange":
            return .orange
        case "gray":
            return .gray
        case "blue":
            return .blue
        case "white":
            return .white
        case "purple":
            return .purple
        default:
            return .yellow
        }
    }
}
