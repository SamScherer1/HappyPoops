//
//  TrackCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation

class TrackCell: UITableViewCell {
    
    var timeLabel = UILabel()
    var insetBackgroundView = UIView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    func setupView() {
        self.insetBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        [self addSubview:self.insetBackgroundView];
        self.addSubview(self.insetBackgroundView)
//
//        [self.insetBackgroundView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5.0].active = YES;
        self.insetBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
//        [self.insetBackgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5.0].active = YES;
        self.insetBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
        //
//        self.insetBackgroundView.layer.cornerRadius = 15.0;
        self.insetBackgroundView.layer.cornerRadius = 15.0
//
//        self.insetBackgroundView.backgroundColor = [UIColor halfTransparentDarkColor];
        self.insetBackgroundView.backgroundColor = .gray//TODO: use extension
//
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = .clear
    }
}
