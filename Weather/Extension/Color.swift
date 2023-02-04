import SwiftUI

extension Color {
    func tempColor(temp: Double) -> Color {
        if temp<10 {
            return Color("LightBlue")
        } else if (10...25).contains(temp) {
            return Color.orange
        } else {
            return Color.red
        }
    }
}
