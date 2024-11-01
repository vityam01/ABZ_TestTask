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
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                return .failure(.serverError("Server returned status code \(httpResponse.statusCode)"))
            }

            let decodedResponse = try JSONDecoder().decode(UserListResponse.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(.serverError(error.localizedDescription))
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
    
    

    // MARK: Register User
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
            print("Header set: \(field): \(value)")
        }
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        print("Content-Type set with boundary: \(boundary)")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n\(name)\r\n".data(using: .utf8)!)
        print("Appended name: \(name)")
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n\(email)\r\n".data(using: .utf8)!)
        print("Appended email: \(email)")
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"phone\"\r\n\r\n\(phone)\r\n".data(using: .utf8)!)
        print("Appended phone: \(phone)")
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"position_id\"\r\n\r\n\(positionId)\r\n".data(using: .utf8)!)
        print("Appended position_id: \(positionId)")
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(photoData)
        body.append("\r\n".data(using: .utf8)!)
        print("Appended photo data")
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        print("HTTP body prepared")
        
        print("Sending POST request to: \(request.url?.absoluteString ?? "URL not set")")
        print("HTTP method: \(request.httpMethod ?? "Method not set")")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post request error - \(error)")
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                completion(.failure(.serverError(error?.localizedDescription ?? "No data received.")))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            print("Data received: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("JSON response: \(jsonResponse ?? [:])")
                
                if let success = jsonResponse?["success"] as? Bool, success {
                    if let userId = jsonResponse?["user_id"] as? Int {
                        completion(.success("User registered with ID: \(userId)"))
                    }
                } else if let message = jsonResponse?["message"] as? String, let fails = jsonResponse?["fails"] as? [String: [String]] {
                    if let emailErrors = fails["email"] {
                        print("Email validation error: \(emailErrors.joined(separator: ", "))")
                        completion(.failure(.serverError("Email validation error: \(emailErrors.joined(separator: ", "))")))
                    } else {
                        completion(.failure(.serverError(message)))
                    }
                }
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }


}

