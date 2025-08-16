//
//  Constants.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import Foundation
import SwiftUI

// MARK: - API Configuration
enum APIConfig {
    static let baseURL = "https://api.open-meteo.com/v1"
    static let defaultLocation = (lat: 37.7749, lon: -122.4194) // San Francisco
    static let timeoutInterval: TimeInterval = 30
}

// MARK: - UI Constants
enum UIConstants {
    static let cornerRadius: CGFloat = 12
    static let cardCornerRadius: CGFloat = 15
    static let largeCornerRadius: CGFloat = 20
    
    static let padding: CGFloat = 20
    static let largePadding: CGFloat = 40
    static let smallPadding: CGFloat = 10
    
    static let spacing: CGFloat = 20
    static let largeSpacing: CGFloat = 30
    static let smallSpacing: CGFloat = 10
    
    static let cardHeight: CGFloat = 100
    static let iconSize: CGFloat = 30
    static let largeIconSize: CGFloat = 50
}

// MARK: - Colors
enum AppColors {
    static let primary = Color.blue
    static let secondary = Color.purple
    static let accent = Color.yellow
    static let background = Color.black
    static let cardBackground = Color.white.opacity(0.1)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textTertiary = Color.white.opacity(0.5)
}

// MARK: - Fonts
enum AppFonts {
    static let title = Font.system(size: 36, weight: .bold, design: .rounded)
    static let largeTitle = Font.system(size: 48, weight: .bold, design: .rounded)
    static let headline = Font.system(size: 24, weight: .bold, design: .rounded)
    static let body = Font.system(size: 18, weight: .medium, design: .rounded)
    static let caption = Font.system(size: 14, weight: .medium, design: .rounded)
    static let smallCaption = Font.system(size: 12, weight: .medium, design: .rounded)
}

// MARK: - Weather Icons
enum WeatherIcons {
    static let clearSky = "sun.max.fill"
    static let partlyCloudy = "cloud.sun.fill"
    static let cloudy = "cloud.fill"
    static let rain = "cloud.rain.fill"
    static let snow = "cloud.snow.fill"
    static let thunderstorm = "cloud.bolt.fill"
    static let fog = "cloud.fog.fill"
    
    static let humidity = "humidity.fill"
    static let wind = "wind"
    static let uvIndex = "thermometer.sun.fill"
    static let precipitation = "drop.fill"
    static let sunrise = "sunrise.fill"
    static let sunset = "sunset.fill"
    static let location = "location.circle.fill"
}
