//
//  TagCloudCollectionViewCell.swift
//  TagCloudCollectionViewCell
//
//  Created by Kasumigaoka Utaha on 27.08.21.
//

import UIKit

class TagCloudCollectionViewCell: UICollectionViewCell {
    
    var tagLabel: UILabel! // TODO: Maybe replace UILabel with UIButton for better UX
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
    }
    
    func setup() {
        tagLabel = UILabel(frame: .zero)
        tagLabel.textColor = .label
        contentView.addSubview(tagLabel)
        
        // Autolayout
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
