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

    // See https://stackoverflow.com/a/64390373
    override func systemLayoutSizeFitting(
        _: CGSize,
        withHorizontalFittingPriority _: UILayoutPriority,
        verticalFittingPriority _: UILayoutPriority
    ) -> CGSize {
        collectionView.contentSize
    }
}
