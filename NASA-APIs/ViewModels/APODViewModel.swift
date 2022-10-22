//
//  APODViewModel.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 22/10/2022.
//

import Foundation

struct APODViewModel {
    
    private let nc = NetworkController<APODResponse>()
    private let request = NASAAPIRequest<APODResponse>.apodRequest(date: nil, startDate: nil, endDate: nil, count: nil, thumbs: nil)
    
    var apod: APODResponse {
        get async throws {
            // TODO: Caching
            return try await nc.execute(request)
        }
    }
    
}
