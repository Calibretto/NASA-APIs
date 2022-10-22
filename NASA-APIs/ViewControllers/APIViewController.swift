//
//  APIViewController.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 20/10/2022.
//

import UIKit

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
        }
    }
    
    @objc func apodButtonPressed() {
        self.coordinator?.moveTo(state: .apod)
    }

    private class View: UIView {
        let scrollView = UIScrollView()
        let stackView = UIStackView()
        let apodButton = UIButton()
        
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
            
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.spacing = 8
            
            createViewHierarchy()
            createConstraints()
        }
        
        private func createViewHierarchy() {
            stackView.addArrangedSubview(apodButton)
            
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
    }
}
