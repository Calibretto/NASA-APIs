//
//  NetworkController.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 20/10/2022.
//

import Foundation

enum NetworkControllerError: Error {
    case unableToCreateURLRequest
    case unableToCreateURL
    case parsingError(error: Error)
    case networkingError(error: Error)
    case badResponse
    case unknown
}

class NetworkController<Value: Decodable> {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func execute(_ request: NASAAPIRequest<Value>) async throws -> Value {
        guard let urlRequest = request.urlRequest() else {
            throw NetworkControllerError.unableToCreateURLRequest
        }
        
        do {
            let (data, urlResponse) = try await urlSession.data(for: urlRequest)
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
                throw NetworkControllerError.badResponse
            }
            
            guard (200..<300).contains(httpURLResponse.statusCode) else {
                throw NetworkControllerError.badResponse
            }
            
            let object: Value
            do {
                object = try JSONDecoder().decode(Value.self, from: data)
            } catch {
                throw NetworkControllerError.parsingError(error: error)
            }
            return object
        } catch {
            throw NetworkControllerError.networkingError(error: error)
        }
    }
}
