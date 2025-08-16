//
//  CurrentWeatherView.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import SwiftUI

struct CurrentWeatherView: View {
    let currentWeather: ProcessedCurrentWeather
    let location: Location
    let weatherService: WeatherService
    
    var body: some View {
        VStack(spacing: 30) {
            // Location Header
            VStack(spacing: 10) {
                Text(location.name)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                if let state = location.state {
                    Text("\(state), \(location.country)")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                } else {
                    Text(location.country)
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Current Weather Info
            HStack(spacing: 60) {
                // Temperature and Weather Icon
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        Text(weatherService.formatTemperature(currentWeather.temp))
                            .font(.system(size: 120, weight: .thin, design: .rounded))
                            .foregroundColor(.white)
                        
                        if let weatherIcon = currentWeather.weather.first {
                            Image(systemName: weatherService.getWeatherIcon(for: weatherIcon.icon))
                                .font(.system(size: 80))
                                .foregroundColor(weatherService.getWeatherColorAsColor(for: weatherIcon.icon))
                        }
                    }
                    
                    if let weatherDescription = currentWeather.weather.first {
                        Text(weatherDescription.description.capitalized)
                            .font(.system(size: 28, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Text("Feels like \(weatherService.formatTemperature(currentWeather.feelsLike))")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                // Weather Details
                VStack(alignment: .leading, spacing: 25) {
                    WeatherDetailRow(
                        icon: "humidity.fill",
                        title: "Humidity",
                        value: "\(currentWeather.humidity)%",
                        color: .blue
                    )
                    
                    WeatherDetailRow(
                        icon: "wind",
                        title: "Wind",
                        value: "\(Int(round(currentWeather.windSpeed))) km/h \(weatherService.getWindDirection(currentWeather.windDeg))",
                        color: .cyan
                    )
                    
                    WeatherDetailRow(
                        icon: "eye.fill",
                        title: "Visibility",
                        value: "\(currentWeather.visibility / 1000) km",
                        color: .green
                    )
                    
                    WeatherDetailRow(
                        icon: "gauge",
                        title: "Pressure",
                        value: "\(currentWeather.pressure) hPa",
                        color: .orange
                    )
                    
                    WeatherDetailRow(
                        icon: "thermometer.sun.fill",
                        title: "UV Index",
                        value: String(format: "%.1f", currentWeather.uvi),
                        color: .red
                    )
                    
                    WeatherDetailRow(
                        icon: "cloud.fill",
                        title: "Clouds",
                        value: "\(currentWeather.clouds)%",
                        color: .gray
                    )
                }
            }
            
            // Sunrise/Sunset Info
            HStack(spacing: 60) {
                VStack(spacing: 10) {
                    Image(systemName: "sunrise.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.orange)
                    
                    Text("Sunrise")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(weatherService.formatTime(currentWeather.sunrise))
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 10) {
                    Image(systemName: "sunset.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                    
                    Text("Sunset")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(weatherService.formatTime(currentWeather.sunset))
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(60)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.8),
                    Color.purple.opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

struct WeatherDetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(value)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
    }
}

#Preview {
    let sampleWeather = ProcessedCurrentWeather(
        dt: Date().timeIntervalSince1970,
        temp: 22.5,
        feelsLike: 24.0,
        pressure: 1013,
        humidity: 65,
        uvi: 3.5,
        clouds: 20,
        visibility: 10000,
        windSpeed: 12.5,
        windDeg: 180,
        weather: [WeatherDescription(id: 0, main: "Clear sky", description: "clear sky", icon: "0")],
        sunrise: Date().timeIntervalSince1970,
        sunset: Date().timeIntervalSince1970
    )
    
    let sampleLocation = Location(
        name: "San Francisco",
        lat: 37.7749,
        lon: -122.4194,
        country: "US",
        state: "CA"
    )
    
    return CurrentWeatherView(
        currentWeather: sampleWeather,
        location: sampleLocation,
        weatherService: WeatherService()
    )
    .background(Color.black)
}
