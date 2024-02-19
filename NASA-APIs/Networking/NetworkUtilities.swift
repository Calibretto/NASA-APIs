//
//  NetworkUtilities.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 21/10/2022.
//

import Combine
import Foundation
import UIKit

enum NetworkError: Error {
    case unableToCreateURL
    case networkingError(error: Error)
    case invalidData
    case unknown
}

struct NetworkUtilities {
    
    static func loadImage(url urlString: String) throws -> AnyPublisher<UIImage?, Never> {
        guard let url = URL(string: urlString) else {
            throw NetworkError.unableToCreateURL
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
                                .map(\.data)
                                .compactMap { UIImage(data: $0) }
                                .replaceError(with: nil)
                                .eraseToAnyPublisher()
    }

}
