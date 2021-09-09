//
//  RecruitmentTagCloudLayout.swift
//  RecruitmentTagCloudLayout
//
//  Created by Kasumigaoka Utaha on 09.09.21.
//

import UIKit

class RecruitmentTagCloudLayout: UICollectionViewFlowLayout {

    let data: [String]
    let computeCellSize: ((String) -> CGSize)
    
    init(data: [String], computeCellSize: @escaping ((String) -> CGSize)) {
        self.data = data
        self.computeCellSize = computeCellSize

        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView, let dataSource = collectionView.dataSource else { return CGSize.zero }
       
        let contentWidth = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        var size = CGSize.zero
        let itemCount = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        if itemCount == 0 {
            return size
        }
        var lineWidth: CGFloat = 0.0
        var rowCount = 1
        var rowHeight: CGFloat = 0.0

        for i in 0..<itemCount {
            let cellSize = computeCellSize(data[i])
            rowHeight = max(rowHeight, cellSize.height)
            lineWidth += cellSize.width + self.minimumInteritemSpacing
            
            if lineWidth > contentWidth {
                rowCount += 1
                lineWidth = cellSize.width + self.minimumInteritemSpacing
            }
        }
        
        size.height = CGFloat(rowCount) * rowHeight + CGFloat(rowCount - 1) * self.minimumLineSpacing + self.sectionInset.top + self.sectionInset.bottom
        size.width = contentWidth
        
        return size
    }
}
