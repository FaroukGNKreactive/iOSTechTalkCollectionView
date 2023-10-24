//
//  UILabelCollectionViewCell.swift
//  JOParis24
//
//  Created by Farouk GNANDI on 31/03/2023.
//

import UIKit

class UILabelCollectionViewCell: UICollectionViewListCell {
    private weak var stackView: UIStackView!
    
    private weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        addSubview(stackView)
        
        self.stackView = stackView
        self.label = label
    }
    
    private func setupConstraints() {
        let viewsDictionary = ["stackView": stackView!]
        
        let metricsDictionary: [String: Any]? = nil
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[stackView]-|",
                                                                   options: [],
                                                                   metrics: metricsDictionary,
                                                                   views: viewsDictionary))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[stackView]-|",
                                                                   options: [],
                                                                   metrics: metricsDictionary,
                                                                   views: viewsDictionary))
    }
    
    func configure(description: String) {
        label.text = description
    }
}
