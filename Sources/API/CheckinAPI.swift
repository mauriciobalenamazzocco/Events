import Foundation

protocol CheckinAPIProtocol {
    typealias CheckinResult = Result<Void, ServiceError>

    func checkin(url: String, id: String, email: String, name: String, completionHandler: @escaping (CheckinResult) -> Void)
}

struct CheckinAPI: CheckinAPIProtocol {

    let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func checkin(url: String,
                 id: String,
                 email: String,
                 name: String,
                 completionHandler: @escaping (CheckinResult) -> Void) {

        let checkin = Checkin(eventId: id, name: name, email: email)

        guard let url = URL(string: url) else {
            return completionHandler(.failure(.urlInvalid))

        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        guard let jsonData = try? encoder.encode(checkin) else {
            completionHandler(.failure(.parse))
            return
        }

        request.httpBody = jsonData

        let dataTask = urlSession.dataTask(with: request) { data, _, error in
            if let error = error {
                completionHandler(.failure(.api(error)))
            } else if let data = data {

                guard let checkinResponse = try? JSONDecoder().decode(CheckinResponse.self, from: data) else {
                    completionHandler(.failure(.parse))
                    return
                }
                if let responseCode = checkinResponse.code,
                    responseCode == "200" {
                    completionHandler(.success(Void()))
                    return
                }
                completionHandler(.failure(.unauthorized))
            }
        }
        dataTask.resume()
    }
}

extension CheckinAPI {
    static let checkinPath = "\(API.path)/checkin" //This api is not pageable =(

}
