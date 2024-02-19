//
//  APODViewModel.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 22/10/2022.
//

import Combine
import Foundation

class APODViewModel {
    
    private let nc = NetworkController<APODResponse>()
    private let request = NASAAPIRequest<APODResponse>.apodRequest(date: nil, startDate: nil, endDate: nil, count: nil, thumbs: nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var apod: APODResponse? = nil
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
                    self.apod = response
                })
                .store(in: &cancellables)
        } catch {
            self.error = error
        }
    }
}
