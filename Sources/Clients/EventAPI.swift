import Foundation
import RxSwift
import RxCocoa

protocol EventAPIProtocol {
    typealias EventsResponse = Result<[Occurrence], ServiceError>

    func fetchAllEvents(completionHandler: @escaping (EventsResponse) -> Void)
}

struct EventAPI: EventAPIProtocol {

    let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchAllEvents(completionHandler: @escaping (EventsResponse) -> Void ) {

        guard let url = URL(string: EventAPI.apiEventPath) else {
            completionHandler(.failure(.urlInvalid))
            return
        }

        let dataTask = urlSession.dataTask(with: URLRequest(url: url)) { (data, _, error) in
            if let error = error {
                completionHandler(.failure(.api(error)))
            } else if let data = data {
                guard let ocurrences = try? JSONDecoder().decode([Occurrence].self, from: data) else {
                    completionHandler(.failure(.parse))
                    return
                }

                completionHandler(.success(ocurrences))
            }
        }
        dataTask.resume()
    }
}

extension EventAPI {
    static let apiEventPath = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events" //This api is not pageable =(
}
