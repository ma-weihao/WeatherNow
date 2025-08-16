//
//  WeatherModels.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import Foundation

// MARK: - Open-Meteo API Response Models
struct WeatherResponse: Codable {
    let current: CurrentWeather
    let hourly: HourlyData
    let daily: DailyData
    let latitude: Double
    let longitude: Double
    let timezone: String
    let timezoneAbbreviation: String
    let elevation: Double
    
    enum CodingKeys: String, CodingKey {
        case current, hourly, daily, latitude, longitude, timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
    }
}

struct CurrentWeather: Codable {
    let time: String
    let temperature2m: Double
    let relativeHumidity2m: Int
    let apparentTemperature: Double
    let precipitation: Double
    let weatherCode: Int
    let pressureMsl: Double
    let windSpeed10m: Double
    let windDirection10m: Int
    let visibility: Double
    
    enum CodingKeys: String, CodingKey {
        case time, precipitation, visibility
        case temperature2m = "temperature_2m"
        case relativeHumidity2m = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case weatherCode = "weather_code"
        case pressureMsl = "pressure_msl"
        case windSpeed10m = "wind_speed_10m"
        case windDirection10m = "wind_direction_10m"
    }
}

struct HourlyData: Codable {
    let time: [String]
    let temperature2m: [Double]
    let relativeHumidity2m: [Int]
    let apparentTemperature: [Double]
    let precipitationProbability: [Int]
    let weatherCode: [Int]
    let pressureMsl: [Double]
    let windSpeed10m: [Double]
    let windDirection10m: [Int]
    let visibility: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case relativeHumidity2m = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitationProbability = "precipitation_probability"
        case weatherCode = "weather_code"
        case pressureMsl = "pressure_msl"
        case windSpeed10m = "wind_speed_10m"
        case windDirection10m = "wind_direction_10m"
        case visibility
    }
}

struct DailyData: Codable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    let apparentTemperatureMax: [Double]
    let apparentTemperatureMin: [Double]
    let precipitationProbabilityMax: [Int]
    let sunrise: [String]
    let sunset: [String]
    let uvIndexMax: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time, sunrise, sunset
        case weatherCode = "weather_code"
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case apparentTemperatureMax = "apparent_temperature_max"
        case apparentTemperatureMin = "apparent_temperature_min"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case uvIndexMax = "uv_index_max"
    }
}

// MARK: - Processed Weather Models for UI
struct ProcessedCurrentWeather {
    let dt: TimeInterval
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherDescription]
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct ProcessedHourlyWeather {
    let dt: TimeInterval
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherDescription]
    let pop: Double
}

struct ProcessedDailyWeather {
    let dt: TimeInterval
    let sunrise: TimeInterval
    let sunset: TimeInterval
    let temp: Temperature
    let feelsLike: FeelsLike
    let pressure: Int
    let humidity: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherDescription]
    let clouds: Int
    let pop: Double
    let uvi: Double
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct WeatherDescription: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Location Models
struct Location: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}

// MARK: - Weather Code Mapping for Open-Meteo
enum WeatherCode: Int, CaseIterable {
    case clearSky = 0
    case mainlyClear = 1
    case partlyCloudy = 2
    case overcast = 3
    case fog = 45
    case rimeFog = 48
    case drizzleLight = 51
    case drizzleModerate = 53
    case drizzleDense = 55
    case rainSlight = 61
    case rainModerate = 63
    case rainHeavy = 65
    case rainFreezingSlight = 71
    case rainFreezingHeavy = 75
    case snowSlight = 73
    case snowModerate = 76
    case snowHeavy = 77
    case snowGrains = 78
    case rainShowersSlight = 80
    case rainShowersModerate = 81
    case rainShowersViolent = 82
    case snowShowersSlight = 85
    case snowShowersHeavy = 86
    case thunderstormSlight = 95
    case thunderstormModerate = 96
    case thunderstormHeavy = 99
    
    var systemName: String {
        switch self {
        case .clearSky, .mainlyClear:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .overcast:
            return "cloud.fill"
        case .fog, .rimeFog:
            return "cloud.fog.fill"
        case .drizzleLight, .drizzleModerate, .drizzleDense, .rainSlight, .rainModerate, .rainHeavy:
            return "cloud.rain.fill"
        case .rainFreezingSlight, .rainFreezingHeavy, .snowSlight, .snowModerate, .snowHeavy, .snowGrains:
            return "cloud.snow.fill"
        case .rainShowersSlight, .rainShowersModerate, .rainShowersViolent:
            return "cloud.rain.fill"
        case .snowShowersSlight, .snowShowersHeavy:
            return "cloud.snow.fill"
        case .thunderstormSlight, .thunderstormModerate, .thunderstormHeavy:
            return "cloud.bolt.rain.fill"
        }
    }
    
    var color: String {
        switch self {
        case .clearSky, .mainlyClear:
            return "yellow"
        case .partlyCloudy:
            return "orange"
        case .overcast:
            return "gray"
        case .fog, .rimeFog:
            return "gray"
        case .drizzleLight, .drizzleModerate, .drizzleDense, .rainSlight, .rainModerate, .rainHeavy:
            return "blue"
        case .rainFreezingSlight, .rainFreezingHeavy, .snowSlight, .snowModerate, .snowHeavy, .snowGrains:
            return "cyan"
        case .rainShowersSlight, .rainShowersModerate, .rainShowersViolent:
            return "blue"
        case .snowShowersSlight, .snowShowersHeavy:
            return "cyan"
        case .thunderstormSlight, .thunderstormModerate, .thunderstormHeavy:
            return "purple"
        }
    }
    
    var description: String {
        switch self {
        case .clearSky:
            return "Clear sky"
        case .mainlyClear:
            return "Mainly clear"
        case .partlyCloudy:
            return "Partly cloudy"
        case .overcast:
            return "Overcast"
        case .fog:
            return "Fog"
        case .rimeFog:
            return "Rime fog"
        case .drizzleLight:
            return "Light drizzle"
        case .drizzleModerate:
            return "Moderate drizzle"
        case .drizzleDense:
            return "Dense drizzle"
        case .rainSlight:
            return "Slight rain"
        case .rainModerate:
            return "Moderate rain"
        case .rainHeavy:
            return "Heavy rain"
        case .rainFreezingSlight:
            return "Slight freezing rain"
        case .rainFreezingHeavy:
            return "Heavy freezing rain"
        case .snowSlight:
            return "Slight snow"
        case .snowModerate:
            return "Moderate snow"
        case .snowHeavy:
            return "Heavy snow"
        case .snowGrains:
            return "Snow grains"
        case .rainShowersSlight:
            return "Slight rain showers"
        case .rainShowersModerate:
            return "Moderate rain showers"
        case .rainShowersViolent:
            return "Violent rain showers"
        case .snowShowersSlight:
            return "Slight snow showers"
        case .snowShowersHeavy:
            return "Heavy snow showers"
        case .thunderstormSlight:
            return "Slight thunderstorm"
        case .thunderstormModerate:
            return "Moderate thunderstorm"
        case .thunderstormHeavy:
            return "Heavy thunderstorm"
        }
    }
}
