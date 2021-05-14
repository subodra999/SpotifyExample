//
//  RecommendedTrackCollectionViewCell.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 02/05/21.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 4
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 2,
            width: imageSize,
            height: imageSize
        )
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 0,
            width: contentView.width - albumCoverImageView.right - 15,
            height: contentView.height / 2
        )
        
        trackNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: artistNameLabel.bottom,
            width: contentView.width - albumCoverImageView.right - 15,
            height: contentView.height / 2
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
