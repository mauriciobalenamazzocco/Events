import Foundation

struct Occurrence: Codable {
    var id: String?
    var date: Int64?
    var title: String?
    var price: Double?
    var image: String?
    var longitude: Int64?
    var latitude: Int64?
    var description: String?
    var people: [People]?
    var cupons: [Cupon]?
}
