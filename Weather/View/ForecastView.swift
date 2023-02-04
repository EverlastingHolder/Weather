import Foundation
import SwiftUI
import Charts

struct ForecastView: View {
    @ObservedObject
    var viewModel: ForecastViewModel = .init()
    
    @State
    var lat: Double
    @State
    var lon: Double
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewModel.forecast.list!, id: \.self) { item in
                    LineMark(
                        x: .value("Day", item.date),
                        y: .value("Temp", item.main.temp)
                    )
                }
            }
            .onAppear {
                viewModel.getWeatherDay(lat: lat, lon: lon)
            }
        }
    }
}
