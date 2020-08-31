import Foundation
import RxSwift
import RxCocoa

protocol EventAPIProtocol {
    typealias EventsResponse = Result<[Occurrence], ServiceError>
    typealias EventResponse = Result<Occurrence, ServiceError>

    func fetchAllEvents(completionHandler: @escaping (EventsResponse) -> Void)
    func fetchEventDetail(id: String, completionHandler: @escaping (EventResponse) -> Void)
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

    func fetchEventDetail(id: String,
                          completionHandler: @escaping (EventResponse) -> Void ) {

        guard let url = URL(string: String(format: EventAPI.apiEventPath, id)) else {
            completionHandler(.failure(.urlInvalid))
            return
        }

        let dataTask = urlSession.dataTask(with: URLRequest(url: url)) { (data, _, error) in
            if let error = error {
                completionHandler(.failure(.api(error)))
            } else if let data = data {
                guard let ocurrences = try? JSONDecoder().decode(Occurrence.self, from: data) else {
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
    static let apiEventPath = "\(API.path)/events" //This api is not pageable =(
    static let apiEventDetailPath = "\(API.path)/events/%@"
}
