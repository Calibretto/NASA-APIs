//
//  MarsRoverPhotosViewModel.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 18/02/2024.
//

import Foundation

struct MarsRoverPhotosViewModel {
    
    private let nc = NetworkController<MarsRoverPhotosResponse>()
    private let request = NASAAPIRequest<MarsRoverPhotosResponse>.marsRoverPhotosRequest()
    
    var marsRoverPhotos: [MarsRoverPhoto] {
        get async throws {
            // TODO: Caching
            return try await nc.execute(request).photos
        }
    }
    
}
