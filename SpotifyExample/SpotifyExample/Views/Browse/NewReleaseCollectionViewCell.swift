//
//  NewReleaseCollectionViewCell.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 02/05/21.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let numOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 10
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width - albumCoverImageView.right - 10,
                height: contentView.height - 10
            )
        )
        albumNameLabel.sizeToFit()
        numOfTracksLabel.sizeToFit()

        // Labels
        let albumLabelHeight = min(60, albumLabelSize.height)
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 5,
            width: albumLabelSize.width,
            height: albumLabelHeight
        )
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: albumNameLabel.bottom,
            width: contentView.width - albumCoverImageView.right - 10,
            height: 30
        )
        
        numOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: contentView.bottom - 44,
            width: contentView.width - albumCoverImageView.right - 10,
            height: 44
        )

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text = nil
        albumNameLabel.text = nil
        numOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        artistNameLabel.text = viewModel.artistName
        albumNameLabel.text = viewModel.name
        numOfTracksLabel.text = "Tracks:- \(viewModel.numOfTracks ?? 0)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
