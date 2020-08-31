import Foundation

extension Double {
    func getDateStringFromUnixTime(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: Date(timeIntervalSince1970: self / 1000))
    }
}
