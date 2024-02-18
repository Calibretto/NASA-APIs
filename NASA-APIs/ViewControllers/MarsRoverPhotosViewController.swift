//
//  MarsRoverPhotosViewController.swift
//  NASA-APIs
//
//  Created by Brian Hackett on 18/02/2024.
//

import Foundation
import UIKit

class MarsRoverPhotosViewController: UIViewController, CoordinatedViewController {
    weak var coordinator: Coordinator?
    private var viewModel = MarsRoverPhotosViewModel()
    private var photos = [MarsRoverPhoto]() {
        didSet {
            if let view = self.view as? View {
                view.tableView.reloadData()
            }
        }
    }
    
    required init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("apis.mars_rover_photos.title", comment: "Mars Rover Photos Title")
        loadData()
    }
    
    override func loadView() {
        view = View()
        if let view = self.view as? View {
            view.titleLabel.text = title
            view.tableView.dataSource = self
        }
    }
    
    private func loadData() {
        Task {
            do {
                // TODO: Consider if there's a better way to handle this
                photos = try await viewModel.marsRoverPhotos
            } catch {
                displayGenericError()
            }
        }
    }
    
    @MainActor
    private func displayGenericError() {
        let alert = UIAlertController(title: "Error", message: "Oops - something went wrong while loading the Mars Rover photo data.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { _ in
            self.coordinator?.moveTo(state: .main)
        }))
        
        present(alert, animated: true)
    }
    
    private class MarsRoverPhotoCell: UITableViewCell {
        let photoView = UIImageView()
        let dateLabel = UILabel()
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        public func setPhoto(_ photo: MarsRoverPhoto) {
            dateLabel.text = photo.earthDate
            
            // TODO: Display loading view first
            Task {
                do {
                    photoView.image = try await NetworkUtilities.loadImage(url: photo.imgSrc)
                } catch {
                    // TODO: Error handling
                }
            }
        }
        
        private func setup() {
            layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            backgroundColor = .black
            
            dateLabel.textColor = .white
            dateLabel.font = UIFont.Headings.medium
            dateLabel.textAlignment = .center
            
            photoView.contentMode = .scaleAspectFit
            
            createViewHierarchy()
            createConstraints()
        }
        
        private func createViewHierarchy() {
            contentView.addSubview(photoView)
            contentView.addSubview(dateLabel)
        }
        
        private func createConstraints() {
            photoView.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
                photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                photoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
                
                dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                dateLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
                dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            ])
        }
    }
    
    private class View: UIView {
        let titleLabel = UILabel()
        let tableView = UITableView()
        
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
            
            tableView.register(MarsRoverPhotoCell.self, forCellReuseIdentifier: "MarsRoverPhotoCell")
            tableView.rowHeight = UITableView.automaticDimension
            
            createViewHierarchy()
            createConstraints()
        }
        
        private func createViewHierarchy() {
            addSubview(titleLabel)
            addSubview(tableView)
        }
        
        private func createConstraints() {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                
                tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            ])
        }
    }
}

extension MarsRoverPhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MarsRoverPhotoCell", for: indexPath) as? MarsRoverPhotoCell {
            if indexPath.row >= 0 && indexPath.row < photos.count {
                let photo = photos[indexPath.row]
                cell.setPhoto(photo)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
