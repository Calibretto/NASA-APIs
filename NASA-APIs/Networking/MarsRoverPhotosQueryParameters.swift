//
//  MarsRoverPhotosQueryParameters.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 18/02/2024.
//

import Foundation

// https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=DEMO_KEY
struct MarsRoverPhotosQueryParameters: QueryParameters {
    let sol: Int
    let apiKey: String
    
    func createQueryItems() -> [URLQueryItem] {
        var qp = [URLQueryItem]()
        qp.append(URLQueryItem(name: "api_key", value: apiKey))
        qp.append(URLQueryItem(name: "sol", value: String(sol)))
        
        return qp
    }
}
