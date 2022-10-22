//
//  CoordinatedViewController.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 21/10/2022.
//

import Foundation
import UIKit

protocol CoordinatedViewController where Self: UIViewController {
    var coordinator: Coordinator? { get set }
    
    init(coordinator: Coordinator)
}
