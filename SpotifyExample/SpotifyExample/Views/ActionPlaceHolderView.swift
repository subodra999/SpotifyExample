//
//  ActionPlaceHolderView.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 29/05/21.
//

import UIKit

struct ActionPlaceHolderViewViewModel {
    let infoText: String
    let actionTitle: String
}

protocol ActionPlaceHolderViewDelegate: AnyObject {
    func actionPlaceHolderViewDidTapButton(_ actionView: ActionPlaceHolderView)
}

class ActionPlaceHolderView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()

    weak var delegate: ActionPlaceHolderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(
            x: 0,
            y: height - 40,
            width: width,
            height: 40
        )
        label.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height - 45
        )
    }
    
    @objc func didTapButton() {
        delegate?.actionPlaceHolderViewDidTapButton(self)
    }

    func configure(with model: ActionPlaceHolderViewViewModel) {
        label.text = model.infoText
        button.setTitle(model.actionTitle, for: .normal)
    }
}
