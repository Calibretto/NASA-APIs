//
//  APODQueryParameters.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 20/10/2022.
//

import Foundation

struct APODQueryParameters: QueryParameters {
    let date: Date?
    let startDate: Date?
    let endDate: Date?
    let count: Int?
    let thumbs: Bool?
    let apiKey: String
    
    func createQueryItems() -> [URLQueryItem] {
        var qp = [URLQueryItem]()
        qp.append(URLQueryItem(name: "api_key", value: apiKey))
        // TODO: date parsing
        if let count {
            qp.append(URLQueryItem(name: "count", value: String(count)))
        }
        if let thumbs {
            qp.append(URLQueryItem(name: "thumbs", value: thumbs ? "True" : "False"))
        }
        
        return qp
    }
}
