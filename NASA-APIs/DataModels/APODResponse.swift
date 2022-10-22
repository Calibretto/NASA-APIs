//
//  APODResponse.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 20/10/2022.
//

import Foundation

struct APODResponse: Decodable {
    let copyright: String
    let date: String
    let explanation: String
    let hdURL: String
    let mediaType: String
    let serviceVersion: String
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case copyright
        case date
        case explanation
        case hdURL = "hdurl"
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title
        case url
    }
}
