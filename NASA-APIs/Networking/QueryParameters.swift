//
//  QueryParameters.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 20/10/2022.
//

import Foundation

protocol QueryParameters {
    func createQueryItems() -> [URLQueryItem]
}
