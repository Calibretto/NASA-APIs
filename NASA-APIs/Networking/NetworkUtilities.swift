//
//  NetworkUtilities.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 21/10/2022.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case unableToCreateURL
    case networkingError(error: Error)
    case invalidData
    case unknown
}

struct NetworkUtilities {
    
    private static func requestData(url urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.unableToCreateURL
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            throw NetworkError.networkingError(error: error)
        }
    }
    
    static func loadImage(url: String) async throws -> UIImage {
        let data = try await requestData(url: url)
        if let image = UIImage(data: data) {
            return image
        } else {
            throw NetworkError.invalidData
        }
    }
}
