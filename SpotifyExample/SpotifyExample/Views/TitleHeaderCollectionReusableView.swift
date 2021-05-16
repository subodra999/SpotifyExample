//
//  TitleHeaderCollectionReusableView.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 16/05/21.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
