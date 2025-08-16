//
//  ContentView.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var weatherService = WeatherService()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if weatherService.isLoading {
                LoadingView()
            } else if let errorMessage = weatherService.errorMessage {
                ErrorView(message: errorMessage) {
                    weatherService.requestLocation()
                }
            } else if let currentWeather = weatherService.currentWeather {
                VStack(spacing: 0) {
                    // Header
                    HeaderView(location: weatherService.location ?? Location(name: "Current Location", lat: 0, lon: 0, country: "", state: nil))
                    
                    // Tab Content
                    TabView(selection: $selectedTab) {
                        // Current Weather Tab
                        ScrollView {
                            CurrentWeatherView(
                                currentWeather: currentWeather,
                                location: weatherService.location ?? Location(name: "Current Location", lat: 0, lon: 0, country: "", state: nil),
                                weatherService: weatherService
                            )
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        }
                        .tag(0)
                        
                        // Hourly Forecast Tab
                        ScrollView {
                            HourlyForecastView(
                                hourlyForecast: weatherService.hourlyForecast,
                                weatherService: weatherService
                            )
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        }
                        .tag(1)
                        
                        // Daily Forecast Tab
                        ScrollView {
                            DailyForecastView(
                                dailyForecast: weatherService.dailyForecast,
                                weatherService: weatherService
                            )
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        }
                        .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Custom Tab Bar
                    CustomTabBar(selectedTab: $selectedTab)
                }
            } else {
                // Initial state - request location
                VStack(spacing: 30) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                    
                    Text("WeatherNow")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Getting your location...")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Button("Enable Location Access") {
                        weatherService.requestLocation()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Test with Default Location") {
                        weatherService.loadWeatherWithDefaultLocation()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    
                    Button("Debug: Force Weather Data") {
                        // Create sample weather data to test UI
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
                        weatherService.currentWeather = sampleWeather
                        weatherService.location = Location(name: "San Francisco", lat: 37.785834, lon: -122.406417, country: "United States", state: "California")
                        weatherService.isLoading = false
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.green)
                }
            }
        }
        .onAppear {
            // Only request location if we don't have weather data and aren't already loading
            if weatherService.currentWeather == nil && !weatherService.isLoading {
                weatherService.requestLocation()
            }
        }
        .onReceive(weatherService.$currentWeather) { newValue in
            print("ContentView: currentWeather changed to: \(newValue != nil)")
        }
        .onReceive(weatherService.$isLoading) { newValue in
            print("ContentView: isLoading changed to: \(newValue)")
        }
        .onReceive(weatherService.$location) { newValue in
            print("ContentView: location changed to: \(newValue?.name ?? "nil")")
        }
    }
}

struct HeaderView: View {
    let location: Location
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("WeatherNow")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("\(location.name), \(location.country)")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Text(Date(), style: .date)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .background(Color.black.opacity(0.3))
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        ("Current", "thermometer.sun.fill"),
        ("Hourly", "clock.fill"),
        ("Daily", "calendar")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: tabs[index].1)
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == index ? .white : .white.opacity(0.6))
                        
                        Text(tabs[index].0)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(selectedTab == index ? .white : .white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        selectedTab == index ?
                        Color.white.opacity(0.2) :
                        Color.clear
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 2)
                    .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Text("Loading Weather Data...")
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .foregroundColor(.white)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            Text("Oops!")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(message)
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("Try Again") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}
