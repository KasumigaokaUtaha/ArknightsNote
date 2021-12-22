//
//  RecruitmentSelectionTableViewCell.swift
//  RecruitmentSelectionTableViewCell
//
//  Created by Kasumigaoka Utaha on 15.08.21.
//

import UIKit

class RecruitmentSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView! // Why weak?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getCollectionView() -> UICollectionView? {
        return collectionView
    }
    
    // See https://stackoverflow.com/a/64390373
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return collectionView.contentSize
    }
}
