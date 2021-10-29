//
//  HomeMessageCell.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import UIKit

class HomeMessageCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        contentView.layer.cornerRadius = 12
//        contentView.backgroundColor = .systemGray
    }

}
