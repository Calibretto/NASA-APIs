//
//  MarsRoverPhotosResponse.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 18/02/2024.
//

import Foundation

struct MarsRoverPhotosResponse: Decodable {
    let photos: [MarsRoverPhoto]
}

struct MarsRoverPhoto: Decodable {
    let id: Int
    let sol: Int
    let camera: MarsRoverCamera
    let imgSrc: String
    let earthDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sol
        case camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
    }
}

struct MarsRoverCamera: Decodable {
    let id: Int
    let name: String
    let roverId: Int
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case roverId = "rover_id"
        case fullName = "full_name"
    }
}
