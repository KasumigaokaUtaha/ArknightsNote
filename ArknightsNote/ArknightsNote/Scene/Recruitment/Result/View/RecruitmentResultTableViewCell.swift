//
//  RecruitmentResultTableViewCell.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 05.10.21.
//

import UIKit

class RecruitmentResultTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return collectionView.contentSize
    }

}
