import SwiftUI

struct ContentView: View {
    @StateObject
    private var viewModel: WeatherViewModel = .init()
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.weatherApi, id:\.key) { (key, value) in
                    Button(action: {
                        withAnimation() {
//                            viewModel.selectedItem.removeAll()
//                            viewModel.selectedItem.append((key: key, value: value))
//                            viewModel.selectedItem[key] = value
                            viewModel.selectedItem = value
//                            viewModel.weatherApi = viewModel.weatherApi.filter { $0.key != viewModel.selectedItem[0].key }
//                            let index = viewModel.weatherApi.firstIndex(where: { $0.key == viewModel.selectedItem[0].key })
//                            viewModel.weatherApi.insert(contentsOf: viewModel.selectedItem, at: index ?? 0)
                        }
                    }) {
                        VStack(alignment: .leading, spacing: 8) {
                            selectedRow(item: value)
                            defaultRow(item: value)
                        }
                    }
                    .padding(.vertical)
                    .listRowBackground(viewModel.selectedItem?.id == key ? tempColor(temp: value.main.temp) : .clear)
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
