//
//  UIFont+NASAStyles.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 21/10/2022.
//

import Foundation
import UIKit

extension UIFont {
    
    enum Headings {
        static var large = UIFont.systemFont(ofSize: 28)
        static var medium = UIFont.systemFont(ofSize: 20)
    }
    
    enum Buttons {
        static var normal = UIFont.systemFont(ofSize: 16)
    }
    
    enum Body {
        static var normal = UIFont.systemFont(ofSize: 14)
    }
}
