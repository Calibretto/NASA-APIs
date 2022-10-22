//
//  Coordinator.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 21/10/2022.
//

import Foundation
import UIKit

class Coordinator: NSObject {
    
    enum State {
        case initialisation
        case main
        case apod
    }
    
    let navigationController: UINavigationController
    
    override init() {
        navigationController = UINavigationController()
        super.init()
        
        navigationController.viewControllers = [APIViewController(coordinator: self)]
        navigationController.view.backgroundColor = .black
        navigationController.navigationBar.isTranslucent = true
        
        var textAttributes = navigationController.navigationBar.titleTextAttributes ?? [NSAttributedString.Key : Any]()
        textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
        navigationController.navigationBar.titleTextAttributes = textAttributes
    }
    
    func moveTo(state: State) {
        switch state {
        case .initialisation:
            break
        case .main:
            guard navigationController.presentedViewController is APIViewController else {
                navigationController.popToRootViewController(animated: true)
                return
            }
            break
        case .apod:
            guard navigationController.presentedViewController is APODViewController else {
                if (navigationController.presentedViewController is APIViewController) == false {
                    navigationController.popToRootViewController(animated: true)
                }
                
                let apodVC = APODViewController(coordinator: self)
                navigationController.pushViewController(apodVC, animated: true)
                return
            }
            break
        }
    }
}
