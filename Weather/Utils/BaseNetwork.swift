import Foundation
import SwiftUI
import Combine

final class BaseNetwork {
    private let apiKey = "e5c66cdda3795ab6f16f90ae84260181"
    private let baseURL: URL = URL(string:"https://api.openweathermap.org/data/2.5/")!
    private let session: URLSession = .shared
    
    func run<T: Codable>(
        _ path: String = "weather",
        method: String = "GET",
        params: [String: String?] = [:],
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, Error> {
        let request = URLRequest.init(
            baseURL.appendingPathComponent(path),
            method: method,
            params: [
             "appid": apiKey,
             "units": "metric"
            ].merging(params) { (current, _) in }
        )
        
        return self.request(request)
    }
    
    private func request<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return session
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .eraseToAnyPublisher()
    }
}
