//
//  APIManger.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation



protocol APIManager {
    func request<T: Decodable>(
        endpoint: Endpoints,
        method: String,
        headers: [HTTPHeader],
        parameters: [String: Any]?,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}


extension APIManager {
    func request<T: Decodable>(
        endpoint: Endpoints,
        method: String,
        headers: [HTTPHeader] = [],
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: Endpoints.base.rawValue + endpoint.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { header in
            let (key, value) = header.keyValue
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if method == "POST", let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(.serverError("No data received.")))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
