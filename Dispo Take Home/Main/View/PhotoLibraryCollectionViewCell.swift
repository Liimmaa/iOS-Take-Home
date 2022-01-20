//
//  PhotoLibraryCollectionViewCell.swift
//  Dispo Take Home
//
//  Created by Chioma Amanda Mmegwa  on 17/01/2022.
//

import UIKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    // Reset imageview for every cell
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
