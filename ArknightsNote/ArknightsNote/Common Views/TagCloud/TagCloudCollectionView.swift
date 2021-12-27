//
//  TagCloudCollectionView.swift
//  TagCloudCollectionView
//
//  Created by Kasumigaoka Utaha on 15.08.21.
//

import UIKit

class TagCloudCollectionView: UICollectionView {
    // See https://stackoverflow.com/a/64390373
    var didLayoutAction: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()

        didLayoutAction?()
        didLayoutAction = nil
    }

//    override var intrinsicContentSize: CGSize {
//        self.layoutIfNeeded()
//        // return self.contentSize
//        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
//    }
//
//    override var contentSize: CGSize {
//        didSet {
//            self.invalidateIntrinsicContentSize()
//        }
//    }

//    override func reloadData() {
//        super.reloadData()
//        self.invalidateIntrinsicContentSize()
//    }
}
