import SwiftUI

extension Color {
    func tempColor(temp: Double) -> Color {
        if temp<10 { return Color("LightBlue") }
        if (10...25).contains(temp) { return Color.orange }
        return Color.red
        
    }
}
