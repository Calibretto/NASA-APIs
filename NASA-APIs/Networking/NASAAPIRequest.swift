//
//  NASAAPIRequest.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 20/10/2022.
//

import Foundation

let APIKEY = "4808w97T0VkRbBMKcUNPfvN8yk773J5bd1fXs2ov"

struct NASAAPIRequest<Value: Decodable> {
    let url: String
    let method: String
    let queryParameters: QueryParameters?
    
    func makeURL() -> URL? {
        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        
        if let queryParameters {
            urlComponents.queryItems = queryParameters.createQueryItems()
        }
        
        return urlComponents.url
    }
    
    func urlRequest() -> URLRequest? {
        guard let url = makeURL() else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return request
    }
}

extension NASAAPIRequest {
    static func apodRequest(date: Date?, startDate: Date?, endDate: Date?, count: Int?, thumbs: Bool?) -> NASAAPIRequest<APODResponse> {
        let qp = APODQueryParameters(date: date, startDate: startDate, endDate: endDate, count: count, thumbs: thumbs, apiKey: APIKEY)
        return NASAAPIRequest<APODResponse>(url: "https://api.nasa.gov/planetary/apod", method: "GET", queryParameters: qp)
    }
    
    static func marsRoverPhotosRequest(sol: Int = 1000) -> NASAAPIRequest<MarsRoverPhotosResponse> {
        let qp = MarsRoverPhotosQueryParameters(sol: sol, apiKey: APIKEY)
        return NASAAPIRequest<MarsRoverPhotosResponse>(url: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos", method: "GET", queryParameters: qp)
    }
}
