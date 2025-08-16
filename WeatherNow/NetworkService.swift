//
//  NetworkService.swift
//  WeatherNow
//
//  Created by weihao ma on 8/16/25.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        // Don't use convertFromSnakeCase since we have explicit CodingKeys
    }
    
    func fetch<T: Codable>(_ type: T.Type, from url: URL) async throws -> T {
        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: APIConfig.timeoutInterval
        )
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherError.networkError("Invalid response type")
            }
            
            guard httpResponse.statusCode == 200 else {
                throw WeatherError.networkError("HTTP \(httpResponse.statusCode)")
            }
            

            
            do {
                let decoded = try decoder.decode(type, from: data)
                return decoded
            } catch {
                throw WeatherError.networkError(error.localizedDescription)
            }
        } catch let error as WeatherError {
            throw error
        } catch {
            throw WeatherError.networkError(error.localizedDescription)
        }
    }
}

// MARK: - Weather API Service
final class WeatherAPIService {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        let urlString = "\(APIConfig.baseURL)/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,pressure_msl,wind_speed_10m,wind_direction_10m,visibility&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation_probability,weather_code,pressure_msl,wind_speed_10m,wind_direction_10m,visibility&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_probability_max,sunrise,sunset,uv_index_max&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidResponse("Invalid URL")
        }
        
        return try await networkService.fetch(WeatherResponse.self, from: url)
    }
}
