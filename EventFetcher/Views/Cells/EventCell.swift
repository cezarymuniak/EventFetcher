//
//  EventCell.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//


import UIKit

class EventCell: UITableViewCell {
    
    let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(eventImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(dateLabel)
        
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font.withSize(16)
        titleLabel.minimumScaleFactor = 0.7
        
        // Constraints for the image view
        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            eventImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 70),
            eventImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // Constraints for the title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        // Constraints for the subtitle label
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        // Constraints for the date label
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
