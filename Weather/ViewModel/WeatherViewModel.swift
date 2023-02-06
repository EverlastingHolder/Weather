import Foundation
import Combine
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var modelForNavigation: WeatherApiModel = WeatherApiModel()
    @Published var search: String = ""
    @Published var selectedItem: WeatherApiModel? = nil
    @Published var weather: [WeatherApiModel] = []
    @Published var toggle: Bool = false
    @AppStorage("selectedId") var selectedId: Int = -1
    
    private let weatherService: WeatherService = WeatherService()
    private let container = WeatherDataContoller.shared.container
    private let locationManager: LocationManager = LocationManager()
    private var bag: Set<AnyCancellable> = .init()
    
    init() {
        
        if weather.isEmpty {
            loadCachedData()
        }
        
        self.$selectedItem
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .sink { [weak self] _ in
                withAnimation() {
                    self?.moveToTop()
                }
            }
            .store(in: &bag)
        
        self.$search
            .debounce(for: .milliseconds(500), scheduler: Scheduler.main)
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.background)
            .sink { [weak self] result in
                self?.fetchCity(city: result)
            }
            .store(in: &bag)
    }
    
    func moveToTop() {
        if let item = selectedItem {
            if let index = weather.firstIndex(where: {$0.id == item.id}) {
                weather.move(from: index, to: 0)
            }
        }
    }
    
    
    
    func requestCurrentLocation() {
        self.weatherService
            .getCurrentCity(
                lat: locationManager.lastLocation.coordinate.latitude,
                lon: locationManager.lastLocation.coordinate.longitude
            )
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .sink(receiveCompletion: { _ in }) { [weak self] result in
                withAnimation {
                    if self?.selectedItem?.id != result.id {
                        self?.weather.append(result)
                        self?.weather = self?.removeDuplicateElements(weathers: self?.weather ?? []) ?? []
                        self?.selectedItem = result
                        self?.selectedId = result.id ?? -1
                        self?.saveData()
                    }
                }
            }
            .store(in: &bag)
    }
    
    private func fetchCity(city: String) {
        self.weatherService
            .searchCity(city: city)
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .sink(receiveCompletion: { _ in }) { [weak self] result in
                withAnimation {
                    self?.weather.append(result)
                    self?.weather = self?.removeDuplicateElements(weathers: self?.weather ?? []) ?? []
                    self?.saveData()
                }
            }
            .store(in: &bag)
    }
    
    private func loadCachedData() {
        CDPublisher(request: WeatherModel.fetchRequest(), context: container.viewContext)
            .map { item in
                item.map { item2 in
                    WeatherApiModel(
                        coord: .init(
                            lon: item2.coordWeather?.lon,
                            lat: item2.coordWeather?.lat),
                        base: item2.base ?? "",
                        main: .init(
                            temp: item2.mainWeather?.temp ?? 0,
                            feelsLike: item2.mainWeather?.feelsLike,
                            tempMin: item2.mainWeather?.tempMin,
                            tempMax: item2.mainWeather?.tempMax,
                            pressure: Int(item2.mainWeather?.pressure ?? 0),
                            humidity: Int(item2.mainWeather?.humidity ?? 0),
                            seaLevel: Int(item2.mainWeather?.seaLevel ?? 0),
                            grndLevel: Int(item2.mainWeather?.grndLevel ?? 0)
                        ),
                        visibility: Int(item2.visibility),
                        dt: Int(item2.dt),
                        timezone: Int(item2.timezone),
                        id: Int(item2.id),
                        name: item2.name ?? "",
                        cod: Int(item2.cod)
                    )
                    
                }
            }
            .receive(on: Scheduler.main)
            .sink(receiveCompletion: { _ in }) { [weak self] item in
                self?.weather = item
                self?.weather = self?.removeDuplicateElements(weathers: self?.weather ?? []) ?? []
                let index = self?.weather.firstIndex(where: { $0.id == -1 })
                if index != nil {
                    self?.weather.remove(at: index!)
                }
                self?.selectedItem = self?.weather.first(where: { $0.id == self?.selectedId })
            }
            .store(in: &bag)
    }
    
    private func saveDataToCache(weather: [WeatherApiModel]) {
        do {
            weather.forEach { item in
                let weather = WeatherModel(context: self.container.viewContext)
                weather.id = Int32(item.id ?? -1)
                weather.dt = Int32(item.dt)
                weather.name = item.name
                weather.base = item.base
                weather.cod = Int32(item.cod ?? 0)
                weather.timezone = Int32(item.timezone ?? 0)
                weather.visibility = Int32(item.visibility ?? 0)
                weather.mainWeather = MainWeather(context: self.container.viewContext)
                weather.mainWeather?.temp = item.main?.temp ?? 0
                weather.mainWeather?.tempMax = item.main?.tempMax ?? 0
                weather.mainWeather?.tempMin = item.main?.tempMin ?? 0
                weather.mainWeather?.feelsLike = item.main?.feelsLike ?? 0
                weather.mainWeather?.seaLevel = Int32(item.main?.seaLevel ?? 0)
                weather.mainWeather?.grndLevel = Int32(item.main?.grndLevel ?? 0)
                weather.mainWeather?.pressure = Int32(item.main?.pressure ?? 0)
                weather.mainWeather?.humidity = Int32(item.main?.humidity ?? 0)
                weather.coordWeather = CoordWeather(context: self.container.viewContext)
                weather.coordWeather?.lat = item.coord?.lat ?? 0
                weather.coordWeather?.lon = item.coord?.lon ?? 0
            }
            
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch let error {
            print("Error occur:" + String(describing: error))
        }
    }
    
    private func removeDuplicateElements(weathers: [WeatherApiModel]) -> [WeatherApiModel] {
        var unique = [WeatherApiModel]()
        for weather in weathers {
            if !unique.contains(where: { $0.id == weather.id }) {
                withAnimation {
                    unique.append(weather)
                }
            }
        }
        return unique
    }
    
    func saveData() {
        self.saveDataToCache(weather: self.weather)
        print("save")
    }
    
    deinit {
        bag.forEach { $0.cancel() }
        bag.removeAll()
    }
}
