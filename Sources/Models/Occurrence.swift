import Foundation

struct Occurrence: Codable {
    var id: String?
    var date: Double?
    var title: String?
    var price: Double?
    var image: String?
    var longitude: Double?
    var latitude: Double?
    var description: String?
    var people: [People]?
    var cupons: [Cupon]?
}
