//
//  NetworkClient.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 18.07.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidBaseURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data?)
    case requestFailed(Error)
    case encodingError(Error)
    case decodingError(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

final class NetworkClient {
    
    static let shared = NetworkClient()
    
    private let session: URLSession
    private let baseURL: URL
    private let token: String
    
    private init(
        session: URLSession = .shared,
        baseURLString: String = baseAPIURL,
        token: String = apiKey
    ) {
        guard let url = URL(string: baseURLString) else {
            fatalError("Invalid base API URL: \(baseURLString)")
        }
        self.baseURL = url
        self.token = token
        self.session = session
    }
    
    func request<ResponseBody: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:]
    ) async throws -> ResponseBody {
        try await performRequest(
            endpoint: endpoint,
            method: method,
            body: nil,
            headers: headers
        )
    }
    
    func request<RequestBody: Encodable, ResponseBody: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: RequestBody,
        headers: [String: String] = [:]
    ) async throws -> ResponseBody {
        let jsonData: Data
        do {
            jsonData = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.encodingError(error)
        }
        
        return try await performRequest(
            endpoint: endpoint,
            method: method,
            body: jsonData,
            headers: headers
        )
    }
    
    func performNoContentRequest(
            endpoint: String,
            method: HTTPMethod = .delete,
            headers: [String: String] = [:]
    ) async throws {
        let path = endpoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.httpError(statusCode: http.statusCode, data: nil)
        }
    }
    
    private func performRequest<ResponseBody: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data?,
        headers: [String: String]
    ) async throws -> ResponseBody {
        let parts = endpoint.split(separator: "?", maxSplits: 1).map(String.init)
        let rawPath   = parts[0].trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let rawQuery  = parts.count > 1 ? parts[1] : nil
        
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(rawPath),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidBaseURL
        }
        
        if let q = rawQuery {
            components.queryItems = q
                .split(separator: "&")
                .map(String.init)
                .compactMap { pair in
                    let kv = pair.split(separator: "=", maxSplits: 1).map(String.init)
                    guard kv.count == 2 else { return nil }
                    return URLQueryItem(name: kv[0], value: kv[1])
                }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidBaseURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.requestFailed(error)
        }
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(http.statusCode) else {
            if let body = String(data: data, encoding: .utf8) {
                print("❌ Server returned HTTP \(http.statusCode) with body:")
                print(body)
            } else {
                print("❌ Server returned HTTP \(http.statusCode) with non-UTF8 body, \(data.count) bytes")
            }
            throw NetworkError.httpError(statusCode: http.statusCode, data: data)
        }
        
        do {
            return try JSONDecoder().decode(ResponseBody.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
