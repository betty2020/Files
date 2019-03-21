//
//  DocumentCollectionViewCell.swift
//  Files
//
//  Created by 翟泉 on 2019/3/18.
//  Copyright © 2019 cezres. All rights reserved.
//

import UIKit
import SnapKit

class DocumentCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor.white
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = ColorWhite(220)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func itemSize(for width: CGFloat) -> CGSize {
        return CGSize(width: width, height: width + UIFont.systemFont(ofSize: 12).lineHeight * 2)
    }

    var file: File! {
        didSet {
            iconImageView.image = nil
            file.thumbnail { (result) in
                self.iconImageView.image = result
            }
            nameLabel.text = file.name
        }
    }

    // MARK: - View
    func setupUI() {
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(nameLabel.font.lineHeight*2)
        }

        self.contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(self.snp.width).offset(-20)
            make.top.equalTo(10)
        }
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isOpaque = true
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.isOpaque = true
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        return label
    }()
}