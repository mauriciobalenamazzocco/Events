import Foundation

// TODO: HTTP Error
enum ServiceError: Error, Equatable {
    case parse
    case urlInvalid
    case api(Error)
    case unauthorized

    static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.urlInvalid, .urlInvalid):
            return true
        case (let .api(error1), let .api(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.parse, .parse):
            return true
        case (.unauthorized, .unauthorized):
            return true
        default:
            return false
        }
    }
}
