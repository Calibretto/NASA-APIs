//
//  NetworkController.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 20/10/2022.
//

import Foundation
import Combine

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
    
    func execute(_ request: NASAAPIRequest<Value>) throws -> AnyPublisher<Value, Error> {
        guard let url = request.makeURL() else {
            throw NetworkControllerError.unableToCreateURL
        }
            
        return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: Value.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }
}
