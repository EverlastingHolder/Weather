import SwiftUI

struct WeatherView: View {
    @StateObject
    private var viewModel: WeatherViewModel = .init()
    @State
    private var isPresented: Bool = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.weather, id:\.id) { item in
                    Button(action: {
                        withAnimation() {
                            if viewModel.selectedItem?.id != item.id {
                                viewModel.selectedItem = item
                            }
                        }
                    }) {
                        VStack(alignment: .leading, spacing: 8) {
                            selectedRow(item: item)
                            defaultRow(item: item)
                        }
                    }
                    .listRowBackground(
                        viewModel.selectedItem?.id == item.id
                        ?
                        Color("").tempColor(temp: item.main?.temp ?? 0 ).animation(.default)
                        :
                        Color.clear.animation(.default)
                    )
                }
            }
            .navigationDestination(isPresented: $isPresented) {
                ForecastView(
                    viewModel: .init(
                        lat: viewModel.modelForNavigation.coord?.lat ?? 0,
                        lon: viewModel.modelForNavigation.coord?.lon ?? 0,
                        toggle: viewModel.toggle
                    )
                )
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
        VStack(alignment: .leading, spacing: 8) {
            Text(item.name ?? "")
                .font(.title)
            HStack {
                Text("\(item.main?.celciusOrFarenheit(toggle: viewModel.toggle) ?? "") °")
                Toggle(isOn: $viewModel.toggle){
                    Text("F")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Text("C")
                listWeatherButton(item: item)
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
                    Text("\(item.name ?? ""),")
                    Text("\(item.main?.celciusOrFarenheit(toggle: viewModel.toggle) ?? "")° \(viewModel.toggle ? "C" : "F")")
                }
                HStack {
                    Text(item.date)
                }
            }
            Spacer()
            
            listWeatherButton(item: item)
        }
        .opacity(viewModel.selectedItem?.id == item.id ? 0 : 1)
        .frame(maxHeight: viewModel.selectedItem?.id == item.id ? 0 : .infinity)
    }
    
    @ViewBuilder
    private func listWeatherButton(item: WeatherApiModel) -> some View {
        Button(action: {
            self.viewModel.modelForNavigation = item
        }) {
            Image(systemName: "doc.text.magnifyingglass")
        }
        .onChange(of: viewModel.modelForNavigation) { _ in
            isPresented = true
        }
    }
}
