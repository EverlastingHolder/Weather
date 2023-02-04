import Foundation
import SwiftUI
import Charts

struct ForecastView: View {
    @ObservedObject
    var viewModel: ForecastViewModel
    
    var body: some View {
//        VStack {
//            Chart {
//                ForEach(viewModel.forecast.list.prefix(12), id: \.self) { item in
//                    PointMark(
//                        x: .value("Temp", Double(item.main.celciusOrFarenheit(toggle: viewModel.toggle))!),
//                        y: .value("Times", item.date)
//                    )
//                    .foregroundStyle(tempColor(temp: item.main.temp))
//                    .annotation(position: .trailing) {
//                        Text("\(item.main.celciusOrFarenheit(toggle: viewModel.toggle))" + "° \(viewModel.toggle ? "C" : "F")")
//                            .font(.caption)
//                    }
//                }
//
//            }
//            .chartXAxisLabel("Temperature", position: .bottom)
//            .chartYAxisLabel("Date", position: .leading)
//            .onAppear {
//                viewModel.getWeatherDay()
//            }
//        }
        List {
            ForEach(viewModel.forecast.groupDic, id: \.key) { (key, value) in
                Chart {
                    ForEach(value, id: \.dt) { item in
                        BarMark(
                            x: .value("Date", item.time),
                            y: .value("Temp", Double(item.main.celciusOrFarenheit(toggle: viewModel.toggle))!)
                        )
                        .foregroundStyle(tempColor(temp: item.main.temp))
                        .annotation(position: .top) {
                            Text("\(item.main.celciusOrFarenheit(toggle: viewModel.toggle))" + "° \(viewModel.toggle ? "C" : "F")")
                                .font(.caption2)
                        }
                    }
                }

                .chartXAxisLabel(key, position: .leading)
            }
            .padding(.vertical)
        }
        .listStyle(.inset)
        .onAppear {
            viewModel.getWeatherDay()
        }
        .navigationTitle(Text(viewModel.forecast.city.name))
    }
    
    private func tempColor(temp: Double) -> Color {
        if temp<10 {
            return Color("LightBlue")
        } else if (10...25).contains(temp) {
            return Color.orange
        } else {
            return Color.red
        }
    }
}
