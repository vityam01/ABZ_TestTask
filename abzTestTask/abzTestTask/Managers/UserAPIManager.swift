//
//  UserAPIManager.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation



class UserAPIManager: APIManager {
    private var authToken: String?
    private var tokenCreationDate: Date?
    var nextLink: String? = nil
    private let baseURL = Endpoints.base.rawValue
    static let shared = UserAPIManager()

    // MARK: Fetch Token
    func fetchTokenIfNeeded(completion: @escaping (Result<String, APIError>) -> Void) {
        if let token = authToken, isTokenValid() {
            print("TOKEN - \(token)")
            completion(.success(token))
        } else {
            fetchToken(completion: completion)
        }
    }

    private func fetchToken(completion: @escaping (Result<String, APIError>) -> Void) {
        request(endpoint: .token, method: "GET", headers: [.accept("application/json")]) { (result: Result<TokenResponse, APIError>) in
            switch result {
            case .success(let response):
                print("TOKEN - \(response.token)")
                self.authToken = response.token
                self.tokenCreationDate = Date()
                completion(.success(response.token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func isTokenValid() -> Bool {
        guard let creationDate = tokenCreationDate else { return false }
        return Date().timeIntervalSince(creationDate) < 40 * 60
    }
    
    // MARK: - Fetch Users with Pagination and nextLink
    func fetchUsers(nextLink: String? = nil, count: Int) async -> Result<UserListResponse, APIError> {
        let urlString = nextLink ?? "\(Endpoints.base.rawValue)\(Endpoints.users.rawValue)?count=\(count)"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    let decodedResponse = try JSONDecoder().decode(UserListResponse.self, from: data)
                    return .success(decodedResponse)
                case 409:
                    let errorMessage = parseErrorMessage(from: data) ?? "User with this phone or email already exists"
                    return .failure(.serverError(errorMessage, httpResponse))
                case 422:
                    let errorMessage = parseValidationErrors(from: data) ?? "Validation error"
                    return .failure(.serverError(errorMessage, httpResponse))
                default:
                    let generalMessage = parseErrorMessage(from: data) ?? "Unexpected error"
                    return .failure(.serverError("Server returned status code \(httpResponse.statusCode): \(generalMessage)", httpResponse))
                }
            } else {
                return .failure(.serverError("Invalid response received.", nil))
            }
        } catch {
            return .failure(.serverError("Failed to decode response: \(error.localizedDescription)", nil))
        }
    }




    
    // MARK: - Fetch Positions
    func fetchPositions(completion: @escaping (Result<[Position], APIError>) -> Void) {
        request(endpoint: .positions, method: "GET", headers: [.accept("application/json")]) { (result: Result<PositionResponse, APIError>) in
            switch result {
            case .success(let response):
                print("Positions - \(response)")
                guard let positions = response.positions else { return }
                completion(.success(positions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Helper to parse error messages from JSON
    private func parseErrorMessage(from data: Data) -> String? {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let message = json["message"] as? String {
            return message
        }
        return nil
    }

    // Helper to parse detailed validation errors
    private func parseValidationErrors(from data: Data) -> String? {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let fails = json["fails"] as? [String: [String]] {
            let errorMessages = fails.flatMap { $0.value }
            return errorMessages.joined(separator: ", ")
        }
        return nil
    }

    // MARK: - Register User
    func registerUser(
        name: String,
        email: String,
        phone: String,
        positionId: Int,
        photoData: Data,
        token: String,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        let headers: [HTTPHeader] = [
            .accept("application/json"),
            .contentType("multipart/form-data"),
            .token(token)
        ]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "\(Endpoints.base.rawValue)\(Endpoints.users.rawValue)")!)
        request.httpMethod = "POST"
        
        headers.forEach { header in
            let (field, value) = header.keyValue
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n\(name)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n\(email)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"phone\"\r\n\r\n\(phone)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"position_id\"\r\n\r\n\(positionId)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(photoData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                if let httpResponse = response as? HTTPURLResponse {
                    completion(.failure(.serverError(error.localizedDescription, httpResponse)))
                } else {
                    completion(.failure(.serverError(error.localizedDescription, nil)))
                }
                return
            }
            
            guard let data = data else {
                if let httpResponse = response as? HTTPURLResponse {
                    completion(.failure(.serverError("No data received.", httpResponse)))
                } else {
                    completion(.failure(.serverError("No data received.", nil)))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let success = jsonResponse["success"] as? Bool, success {
                        let userId = jsonResponse["user_id"] as? Int ?? 0
                        completion(.success("User registered with ID: \(userId)"))
                    } else {
                        completion(.failure(.serverError("Unexpected response format.", nil)))
                    }
                case 409:
                    let errorMessage = self.parseErrorMessage(from: data) ?? "User with this phone or email already exists"
                    completion(.failure(.serverError(errorMessage, httpResponse)))
                case 422:
                    let validationMessage = self.parseValidationErrors(from: data) ?? "Validation error"
                    completion(.failure(.serverError(validationMessage, httpResponse)))
                default:
                    let generalMessage = self.parseErrorMessage(from: data) ?? "Unexpected error"
                    completion(.failure(.serverError("Status code \(httpResponse.statusCode): \(generalMessage)", httpResponse)))
                }
            }
        }.resume()
    }


}

