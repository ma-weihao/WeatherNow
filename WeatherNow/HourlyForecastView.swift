//
//  HourlyForecastView.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import SwiftUI

struct HourlyForecastView: View {
    let hourlyForecast: [ProcessedHourlyWeather]
    let weatherService: WeatherService
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            HStack {
                Text("24-Hour Forecast")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            // Hourly Forecast Cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Array(hourlyForecast.enumerated()), id: \.offset) { index, hour in
                        HourlyForecastCard(
                            hour: hour,
                            weatherService: weatherService,
                            isCurrentHour: index == 0
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(40)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.6),
                    Color.indigo.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

struct HourlyForecastCard: View {
    let hour: ProcessedHourlyWeather
    let weatherService: WeatherService
    let isCurrentHour: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            // Time
            Text(isCurrentHour ? "Now" : weatherService.formatHourlyTime(hour.dt))
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            // Weather Icon
                        if let weatherIcon = hour.weather.first {
                Image(systemName: weatherService.getWeatherIcon(for: weatherIcon.icon))
                    .font(.system(size: 40))
                    .foregroundColor(weatherService.getWeatherColorAsColor(for: weatherIcon.icon))
            }
            
            // Temperature
            Text(weatherService.formatTemperature(hour.temp))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            // Feels Like
            Text("Feels \(weatherService.formatTemperature(hour.feelsLike))")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
            
            // Additional Details
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "humidity.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                    
                    Text("\(hour.humidity)%")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "wind")
                        .font(.system(size: 14))
                        .foregroundColor(.cyan)
                    
                    Text("\(Int(round(hour.windSpeed))) km/h")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Text("\(hour.clouds)%")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                if hour.pop > 0 {
                    HStack(spacing: 8) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        
                        Text("\(Int(hour.pop * 100))%")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
        .padding(20)
        .frame(width: 140, height: 280)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            isCurrentHour ? Color.yellow : Color.clear,
                            lineWidth: 2
                        )
                )
        )
        .scaleEffect(isCurrentHour ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isCurrentHour)
    }
}

#Preview {
    let sampleHourlyData = [
        ProcessedHourlyWeather(
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
            pop: 0.0
        ),
        ProcessedHourlyWeather(
            dt: Date().timeIntervalSince1970 + 3600,
            temp: 21.0,
            feelsLike: 22.5,
            pressure: 1012,
            humidity: 70,
            uvi: 2.0,
            clouds: 30,
            visibility: 9500,
            windSpeed: 10.0,
            windDeg: 175,
            weather: [WeatherDescription(id: 1, main: "Mainly clear", description: "mainly clear", icon: "1")],
            pop: 0.1
        )
    ]
    
    return HourlyForecastView(
        hourlyForecast: sampleHourlyData,
        weatherService: WeatherService()
    )
    .background(Color.black)
}
