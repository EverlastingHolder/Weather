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
                        tempColor(temp: item.main.temp ).animation(.default)
                        :
                        Color.clear.animation(.default)
                    )
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
        VStack(alignment: .leading, spacing: 8) {
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
                    Text(item.name ?? "" )
                    Text(", " + item.main.celciusOrFarenheit(toggle: viewModel.toggle) + "° \(viewModel.toggle ? "C" : "F")")
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
