//
//  RecruitmentTagCloudCollectionViewCell.swift
//  RecruitmentTagCloudCollectionViewCell
//
//  Created by Kasumigaoka Utaha on 27.08.21.
//

import UIKit

class RecruitmentTagCloudCollectionViewCell: UICollectionViewCell {
    
    var tagLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        tagLabel = UILabel(frame: .zero)
        contentView.addSubview(tagLabel)
        
        // Autolayout
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
