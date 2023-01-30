//
//  PhotoCell.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import UIKit
import SnapKit
import Kingfisher

final class PhotoCell: BaseCollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var photoItem: Photo?

    private let photoLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        view.numberOfLines = .zero
        return view
    }()
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        guard let photoItem = photoItem else { return attributes }
        let ratio = CGFloat(photoItem.height) / CGFloat(photoItem.width)
        let newHeight = attributes.bounds.width * ratio
        attributes.bounds.size.height = newHeight
        return attributes
    }
    
    override func setHierarchy() {
        addSubview(imageView)
        imageView.addSubview(photoLabel)
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        photoLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.leading).offset(10)
            $0.bottom.equalTo(imageView.snp.bottom).inset(10)
        }
    }
    
    func configureAttributes(with item: Photo) {
        let imageUrl = URL(string: item.urls.regular)
        imageView.kf.setImage(with: imageUrl)
        self.photoItem = item
    }
    
    func configureAttributes(with item: Image) {
        let imageUrl = URL(string: item.url)
        imageView.kf.setImage(with: imageUrl)
        imageView.contentMode = .scaleToFill
    }
}
