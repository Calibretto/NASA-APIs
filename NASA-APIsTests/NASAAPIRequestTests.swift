//
//  NASAAPIRequestTests.swift
//  NASA-APIsTests
//
//  Created by Brian Hackett on 20/10/2022.
//

@testable import NASA_APIs
import XCTest

final class NASAAPIRequestTests: XCTestCase {

    let networkController = NetworkControllerMock<APODResponse>()
    
    func testSuccess() async throws {
        try networkController.setResponseOverride(from: "SuccessfulAPODResponse")
        
        // TODO: How do we get rid of the need to add the generic here?
        let request = NASAAPIRequest<APODResponse>.apodRequest(date: nil, startDate: nil, endDate: nil, count: nil, thumbs: nil)
        do {
            let apod = try await networkController.execute(request)
            XCTAssertNotNil(apod)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }

    func testParseFailure() async throws {
        try networkController.setResponseOverride(from: "FailedAPODResponse")
        
        // TODO: How do we get rid of the need to add the generic here?
        let request = NASAAPIRequest<APODResponse>.apodRequest(date: nil, startDate: nil, endDate: nil, count: nil, thumbs: nil)
        do {
            _ = try await networkController.execute(request)
            XCTFail("Expected an error")
        } catch {
            guard case NetworkControllerError.parsingError = error else {
                XCTFail("Unexpected error thrown: \(error)")
                return
            }
        }
    }
}
