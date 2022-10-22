//
//  NetworkControllerMock.swift
//  NASA-APIsTests
//
//  Created by Brian Hackett on 21/10/2022.
//

@testable import NASA_APIs
import Foundation

class NetworkControllerMock<Value: Decodable>: NetworkController<Value> {
    
    private var responseOverride: Data?
    var errorOverride: NetworkControllerError?
    
    func setResponseOverride(from: String) throws {
        if let url = Bundle(for: type(of: self)).url(forResource: from, withExtension: "json") {
            responseOverride = try Data(contentsOf: url)
        }
    }
    
    override func execute(_ request: NASAAPIRequest<Value>) async throws -> Value {
        if let responseOverride {
            do {
                return try JSONDecoder().decode(Value.self, from: responseOverride)
            } catch {
                throw NetworkControllerError.parsingError(error: error)
            }
        } else if let errorOverride {
            throw errorOverride
        } else {
            throw NetworkControllerError.unknown
        }
    }
}
