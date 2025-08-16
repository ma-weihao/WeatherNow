//
//  DailyForecastView.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import SwiftUI

struct DailyForecastView: View {
    let dailyForecast: [ProcessedDailyWeather]
    let weatherService: WeatherService
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            HStack {
                Text("7-Day Forecast")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            // Daily Forecast Cards
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(Array(dailyForecast.enumerated()), id: \.offset) { index, day in
                        DailyForecastCard(
                            day: day,
                            weatherService: weatherService,
                            isToday: index == 0
                        )
                        .id(index) // Ensure proper identification
                    }
                }
                .padding(.bottom, 40) // Add bottom padding for scrolling
            }
        }
        .padding(40)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.indigo.opacity(0.6),
                    Color.purple.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

struct DailyForecastCard: View {
    let day: ProcessedDailyWeather
    let weatherService: WeatherService
    let isToday: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            // Date and Day
            VStack(alignment: .leading, spacing: 8) {
                Text(isToday ? "Today" : weatherService.formatDate(day.dt))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                if isToday {
                    Text("\(weatherService.formatDate(day.dt))")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(width: 120, alignment: .leading)
            
            // Weather Icon
            if let weatherIcon = day.weather.first {
                Image(systemName: weatherService.getWeatherIcon(for: weatherIcon.icon))
                    .font(.system(size: 30))
                    .foregroundColor(weatherService.getWeatherColorAsColor(for: weatherIcon.icon))
                    .frame(width: 60)
            }
            
            // Temperature Range
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("High")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(weatherService.formatTemperature(day.temp.max))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Low")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(weatherService.formatTemperature(day.temp.min))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Text("Feels like \(weatherService.formatTemperature(day.feelsLike.day))")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(width: 120, alignment: .leading)
            
            // Weather Description
            if let weatherDescription = day.weather.first {
                Text(weatherDescription.description.capitalized)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 100, alignment: .leading)
            }
            
            // Key Details
            VStack(alignment: .leading, spacing: 8) {
                WeatherDetailItem(
                    icon: "humidity.fill",
                    value: "\(day.humidity)%",
                    color: .blue
                )
                
                WeatherDetailItem(
                    icon: "wind",
                    value: "\(Int(round(day.windSpeed))) km/h",
                    color: .cyan
                )
                
                if day.pop > 0 {
                    WeatherDetailItem(
                        icon: "drop.fill",
                        value: "\(Int(day.pop * 100))%",
                        color: .blue
                    )
                }
            }
            .frame(width: 100, alignment: .leading)
            
            // Sunrise/Sunset
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "sunrise.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                    
                    Text(weatherService.formatTime(day.sunrise))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "sunset.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                    
                    Text(weatherService.formatTime(day.sunset))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 80, alignment: .leading)
            
            Spacer()
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isToday ? Color.yellow.opacity(0.6) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
        .frame(height: 100) // Fixed height for consistency
    }
}

struct WeatherDetailItem: View {
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    let sampleDailyData = [
        ProcessedDailyWeather(
            dt: Date().timeIntervalSince1970,
            sunrise: Date().timeIntervalSince1970,
            sunset: Date().timeIntervalSince1970,
            temp: Temperature(day: 25.0, min: 18.0, max: 28.0, night: 20.0, eve: 23.0, morn: 19.0),
            feelsLike: FeelsLike(day: 26.0, night: 21.0, eve: 24.0, morn: 20.0),
            pressure: 1013,
            humidity: 65,
            windSpeed: 12.5,
            windDeg: 180,
            weather: [WeatherDescription(id: 0, main: "Clear sky", description: "clear sky", icon: "0")],
            clouds: 20,
            pop: 0.0,
            uvi: 3.5
        ),
        ProcessedDailyWeather(
            dt: Date().timeIntervalSince1970 + 86400,
            sunrise: Date().timeIntervalSince1970 + 86400,
            sunset: Date().timeIntervalSince1970 + 86400,
            temp: Temperature(day: 23.0, min: 16.0, max: 26.0, night: 18.0, eve: 21.0, morn: 17.0),
            feelsLike: FeelsLike(day: 24.0, night: 19.0, eve: 22.0, morn: 18.0),
            pressure: 1012,
            humidity: 70,
            windSpeed: 10.0,
            windDeg: 175,
            weather: [WeatherDescription(id: 1, main: "Mainly clear", description: "mainly clear", icon: "1")],
            clouds: 30,
            pop: 0.1,
            uvi: 2.8
        )
    ]
    
    return DailyForecastView(
        dailyForecast: sampleDailyData,
        weatherService: WeatherService()
    )
    .background(Color.black)
}
