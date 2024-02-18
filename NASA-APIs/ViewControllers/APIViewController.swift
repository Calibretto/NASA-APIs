//
//  APIViewController.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 20/10/2022.
//

import UIKit

// TODO: Make adding a new button easier
class APIViewController: UIViewController, CoordinatedViewController {
    
    weak var coordinator: Coordinator?
    
    required init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("apis.title", comment: "APIs Title")
    }
    
    override func loadView() {
        view = View()
        if let view = view as? View {
            view.addAPODButtonSelector(#selector(apodButtonPressed), target: self)
            view.addMRPButtonSelector(#selector(mrpButtonPressed), target: self)
        }
    }
    
    @objc func apodButtonPressed() {
        self.coordinator?.moveTo(state: .apod)
    }
    
    @objc func mrpButtonPressed() {
        self.coordinator?.moveTo(state: .marsRoverPictures)
    }

    private class View: UIView {
        let scrollView = UIScrollView()
        let stackView = UIStackView()
        let apodButton = UIButton()
        let mrpButton = UIButton()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            backgroundColor = .black
            
            // APOD button
            let apodText = NSLocalizedString("apis.apod", comment: "APOD")
            let apodAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Buttons.normal,
                .foregroundColor: UIColor.red
            ]
            let apodButtonTitle = NSAttributedString(string: apodText, attributes: apodAttributes)
            apodButton.setAttributedTitle(apodButtonTitle, for: .normal)
            apodButton.contentHorizontalAlignment = .center
            
            // Mars Rover Photos button
            let mrpText = NSLocalizedString("apis.mars_rover_photos", comment: "Mars Rover Photos")
            let mrpAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Buttons.normal,
                .foregroundColor: UIColor.red
            ]
            let mrpButtonTitle = NSAttributedString(string: mrpText, attributes: mrpAttributes)
            mrpButton.setAttributedTitle(mrpButtonTitle, for: .normal)
            mrpButton.contentHorizontalAlignment = .center
            
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            
            createViewHierarchy()
            createConstraints()
        }
        
        private func createViewHierarchy() {
            stackView.addArrangedSubview(apodButton)
            stackView.addArrangedSubview(mrpButton)
            
            addSubview(scrollView)
            scrollView.addSubview(stackView)
        }
        
        private func createConstraints() {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                
                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                
                stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1),
                stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            ])
            
            scrollView.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 26, right: 24)
        }
        
        func addAPODButtonSelector(_ selector: Selector, target: Any) {
            apodButton.addTarget(target, action: selector, for: .touchUpInside)
        }
        
        func addMRPButtonSelector(_ selector: Selector, target: Any) {
            mrpButton.addTarget(target, action: selector, for: .touchUpInside)
        }
    }
}
