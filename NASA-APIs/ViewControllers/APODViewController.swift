//
//  APODViewController.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 21/10/2022.
//

import Combine
import Foundation
import UIKit

class APODViewController: UIViewController, CoordinatedViewController {
    weak var coordinator: Coordinator?
    private var viewModel = APODViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    required init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("apis.apod.title", comment: "APOD Title")
        loadData()
    }
    
    override func loadView() {
        view = View()
    }
    
    private func loadData() {
        viewModel.$apod.sink { response in
            if let response {
                self.setAPODResponse(response)
            }
        }
        .store(in: &cancellables)
        
        viewModel.$error.sink { error in
            if error != nil {
                self.displayGenericError()
            }
        }
        .store(in: &cancellables)
    }
    
    private func setAPODResponse(_ apod: APODResponse) {
        DispatchQueue.main.async {
            if let view = self.view as? View {
                view.titleLabel.text = apod.title
                view.descriptionLabel.text = apod.explanation
                
                // TODO: Display loading view first
                if let hdURL = apod.hdURL {
                    do {
                        try NetworkUtilities.loadImage(url: hdURL)
                            .receive(on: DispatchQueue.main)
                            .sink { view.imageView.image = $0 }
                            .store(in: &self.cancellables)
                    } catch {
                        // TODO: Handle error
                    }
                }
            }
        }
    }
    
    private func displayGenericError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Oops - something went wrong while loading the APOD data.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { _ in
                self.coordinator?.moveTo(state: .main)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    private class View: UIView {
        let scrollView = UIScrollView()
        let imageView = UIImageView()
        let titleLabel = UILabel()
        let contentView = UIView()
        let descriptionLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            // TODO: Display loading view first
            
            layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 26, right: 24)
            backgroundColor = .black
            
            titleLabel.textColor = .white
            titleLabel.font = UIFont.Headings.medium
            titleLabel.textAlignment = .center
            
            imageView.contentMode = .scaleAspectFit
            
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
            descriptionLabel.textColor = .white
            descriptionLabel.font = UIFont.Body.normal
            
            scrollView.automaticallyAdjustsScrollIndicatorInsets = false
            
            createViewHierarchy()
            createConstraints()
        }
        
        private func createViewHierarchy() {
            addSubview(titleLabel)
            addSubview(imageView)
            addSubview(scrollView)
            
            contentView.addSubview(descriptionLabel)
            scrollView.addSubview(contentView)
        }
        
        private func createConstraints() {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                
                imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.5),
                
                scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
                scrollView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }
    }
}
