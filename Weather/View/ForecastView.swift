import Foundation
import SwiftUI

struct ForecastView: View {
    @StateObject
    private var viewModel: ForecastViewModel
    
    let lat: Double
    let lon: Double
    
    init(
        lat: Double,
        lon: Double
    ) {
        self.lat = lat
        self.lon = lon
        _viewModel = .init(wrappedValue: ForecastViewModel(lat: lat, lon: lon))
    }
    
    var body: some View {
        Text("fd")
    }
}
