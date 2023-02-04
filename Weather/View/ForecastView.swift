import Foundation
import SwiftUI
import Charts

struct ForecastView: View {
    @ObservedObject
    var viewModel: ForecastViewModel
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewModel.forecast.list, id: \.self) { item in
                    LineMark(
                        x: .value("Temp", Double(item.main.celciusOrFarenheit(toggle: viewModel.toggle))!),
                        y: .value("Times", item.date)
                    )
                }
            }
            .onAppear {
                viewModel.getWeatherDay()
            }
        }
        .navigationTitle(Text(viewModel.forecast.city.name))
    }
}
