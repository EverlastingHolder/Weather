import Foundation

extension DateFormatter {
    static let TIME: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let DAY_MONTH: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM:dd"
        return formatter
    }()
    
    static let DATE_WITH_TIME: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        return formatter
    }()
}
