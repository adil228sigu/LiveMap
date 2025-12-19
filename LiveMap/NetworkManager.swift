import Foundation

struct SendCodeRequest: Codable {
    let email: String
}

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    private let baseURL = URL(string: "https://livemap-api-main-b50329f1a08d.herokuapp.com")!

    // MARK: - Async/Await version (preferred)
    func sendCode(email: String) async throws -> Model {
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/users/sendCode"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SendCodeRequest(email: email)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        try validateHTTP(response: response)

        let decoded = try JSONDecoder().decode(Model.self, from: data)
        return decoded
    }

    // MARK: - Completion handler version (if you need callbacks)
    func sendCode(email: String, completion: @escaping (Result<Model, Error>) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/users/sendCode"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let body = SendCodeRequest(email: email)
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error { return completion(.failure(error)) }
            guard let data, let response else {
                return completion(.failure(NSError(domain: "Network", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
            }
            do {
                try self.validateHTTP(response: response)
                let decoded = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Helpers
    private func validateHTTP(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200..<300).contains(http.statusCode) else {
            throw NSError(domain: "HTTPError", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"])
        }
    }
}
