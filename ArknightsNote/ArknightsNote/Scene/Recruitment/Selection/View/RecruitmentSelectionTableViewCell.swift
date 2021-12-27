//
//  RecruitmentSelectionTableViewCell.swift
//  RecruitmentSelectionTableViewCell
//
//  Created by Kasumigaoka Utaha on 15.08.21.
//

import UIKit

class RecruitmentSelectionTableViewCell: UITableViewCell {
    @IBOutlet private var collectionView: UICollectionView! // Why weak?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getCollectionView() -> UICollectionView? {
        collectionView
    }

    // See https://stackoverflow.com/a/64390373
    override func systemLayoutSizeFitting(
        _: CGSize,
        withHorizontalFittingPriority _: UILayoutPriority,
        verticalFittingPriority _: UILayoutPriority
    ) -> CGSize {
        collectionView.contentSize
    }
}
