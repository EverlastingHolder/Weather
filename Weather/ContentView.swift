import SwiftUI

struct ContentView: View {
    @StateObject
    private var viewModel: WeatherViewModel = .init()
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.weather, id:\.id) { item in
                    Button(action: {
                        withAnimation() {
                            viewModel.selectedItem = item
                            viewModel.moveToTop()
                        }
                    }) {
                        VStack(alignment: .leading, spacing: 8) {
                            selectedRow(item: item)
                            defaultRow(item: item)
                        }
                    }
                    .listRowBackground(viewModel.selectedItem?.id == item.id ? Color.blue.animation(.default) : Color.clear.animation(.default))
                }
            }
            .listStyle(.inset)
            .searchable(text: $viewModel.search)
            .navigationTitle(Text("Weather"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        viewModel.requestCurrentLocation()
                    }) {
                        Image(systemName: "location.north.circle")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectedRow(item: WeatherApiModel) -> some View {
        VStack(alignment: .leading) {
            Text(item.name ?? "")
                .font(.title)
            HStack {
                Text(item.main.celciusOrFarenheit(toggle: viewModel.toggle) + "°")
                Toggle(isOn: $viewModel.toggle){
                    Text("F")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Text("C")
            }
        }
        .opacity(viewModel.selectedItem?.id == item.id ? 1 : 0)
        .frame(maxHeight: viewModel.selectedItem?.id == item.id ? .infinity : 0)
    }
    
    @ViewBuilder
    private func defaultRow(item: WeatherApiModel) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text((item.name ?? "") + ",")
                    Text(item.main.celciusOrFarenheit(toggle: viewModel.toggle) + "° \(viewModel.toggle ? "C" : "F")")
                }
                HStack {
                    Text(item.date)
                }
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "doc.text.magnifyingglass")
            }
        }
        .opacity(viewModel.selectedItem?.id == item.id ? 0 : 1)
        .frame(maxHeight: viewModel.selectedItem?.id == item.id ? 0 : .infinity)
    }
    
    @ViewBuilder
    private func tempColor(temp: Double) -> _ConditionalContent<_ConditionalContent<Color, Color>, Color> {
        if temp<10 {
            Color("LightBlue")
        } else if (10...25).contains(temp) {
            Color.orange
        } else {
            Color.red
        }
    }
    @ViewBuilder
    private func tempColor2(temp: Double) -> _ConditionalContent<_ConditionalContent<Color, Color>, Color> {
        if temp<10 {
            Color.clear
        } else if (10...25).contains(temp) {
            Color.clear
        } else {
            Color.clear
        }
    }
}
