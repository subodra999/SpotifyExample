//
//  CategoryCollectionViewCell.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 17/05/21.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    let colors: [UIColor] = [
        .systemPink,
        .systemTeal,
        .systemPurple,
        .systemGray,
        .systemGreen,
        .systemYellow
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(
            x: 10,
            y: contentView.height / 2,
            width: contentView.width - 20,
            height: contentView.height / 2
        )
        imageView.frame = CGRect(
            x: contentView.width / 2,
            y: 10,
            width: contentView.width / 2,
            height: contentView.height / 2
        )
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
}
