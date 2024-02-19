//
//  MarsRoverPhotosViewModel.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 18/02/2024.
//

import Combine
import Foundation

class MarsRoverPhotosViewModel {
    
    private let nc = NetworkController<MarsRoverPhotosResponse>()
    private let request = NASAAPIRequest<MarsRoverPhotosResponse>.marsRoverPhotosRequest()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var photos: [MarsRoverPhoto]? = nil
    @Published var error: Error? = nil
    
    init() {
        do {
            try nc.execute(request)
                .sink(receiveCompletion: { error in
                    switch error {
                    case .finished:
                        // Nothing
                        break
                    case .failure(let error):
                        self.error = error
                    }
                }, receiveValue: { response in
                    self.photos = response.photos
                })
                .store(in: &cancellables)
        } catch {
            self.error = error
        }
    }
    
}
